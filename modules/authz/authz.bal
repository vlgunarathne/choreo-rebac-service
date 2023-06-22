import ballerina/grpc;
import ballerina/log;

import resource_authz_service.constants;
import resource_authz_service.ketoGrpcClient;

public function GetAuthorizedProjectList(ContextGetAuthorizedProjectListRequest request) returns GetAuthorizedProjectListResponse|error {
    var {project_uuids, roles, org_uuid} = request.content;
    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuids.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : Project UUID list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    log:printDebug("Organization [" + org_uuid + "] : Starting to verify permissions of projects list : [" + project_uuids.toString() + "] for the given roles : [" + roles.toString() + "]");
    Project[] allowedProjectUuids = [];
    foreach string prjUuid in project_uuids {
        boolean|error? isRestricted = ketoGrpcClient:checkProjectRestricted(prjUuid, org_uuid);
        if isRestricted is error {
            log:printError("Organization [" + org_uuid + "] : Error while checking if the project is restricted.", isRestricted);
            return error grpc:InternalError(isRestricted.message());
        } else if isRestricted is boolean && isRestricted {
            log:printDebug("Organization [" + org_uuid + "] : Project [" + prjUuid + "] is restricted. Hence checking role permissions.");
            foreach Role role in roles {
                ketoGrpcClient:CheckRequest checkRequest = {
                    tuple: {
                        namespace: constants:NAMESPACE_CHOREO_PROJECTS,
                        'object: org_uuid + constants:PATH_SEPARATOR + prjUuid,
                        relation: constants:PERMISSION_PROJECT_VIEW,
                        subject: {
                            set: {
                                namespace: constants:NAMESPACE_CHOREO_ROLES,
                                'object: org_uuid + constants:PATH_SEPARATOR + role.role_uuid,
                                relation: constants:RELATION_ROLE_HAS
                            }
                        }
                    }
                };
                ketoGrpcClient:CheckResponse|error? checkResponse = ketoGrpcClient:'check(checkRequest);
                if checkResponse is error {
                    log:printError("Organization [" + org_uuid + "] : Error while checking view permission of project [" + prjUuid + "] for role [" + role.role_uuid + "]", checkResponse);
                    return error grpc:InternalError(checkResponse.message());
                } else if checkResponse is ketoGrpcClient:CheckResponse && checkResponse.allowed {
                    log:printDebug("Organization [" + org_uuid + "] : Role [" + role.role_uuid + "] has view permission on project [" + prjUuid + "]");
                    allowedProjectUuids.push({project_uuid: prjUuid});
                } else {
                    log:printDebug("Organization [" + org_uuid + "] : Role [" + role.role_uuid + "] has no permission on project [" + prjUuid + "]");
                }
            }
        } else {
            log:printDebug("Organization [" + org_uuid + "] : Project [" + prjUuid + "] is not restricted. Hence returning project uuid.");
            allowedProjectUuids.push({project_uuid: prjUuid});
        }
    }

    GetAuthorizedProjectListResponse response = {projects: allowedProjectUuids};
    return response;
}

public function GetAuthorizedProject(ContextGetAuthorizedProjectRequest request) returns GetAuthorizedProjectResponse|error {
    var {project_uuid, roles, org_uuid} = request.content;
    string[] projectPermissions = getProjectPermissions();

    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuid == "" {
        string err = "Organization [" + org_uuid + "] : Project UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    log:printDebug("Organization [" + org_uuid + "] : Starting to verify permissions of project : [" + project_uuid + "] for the given roles : [" + roles.toString() + "]");

    boolean|error? isRestricted = ketoGrpcClient:checkProjectRestricted(project_uuid, org_uuid);
    if isRestricted is error {
        log:printError("Organization [" + org_uuid + "] : Error while checking if the project is restricted.", isRestricted);
        return error grpc:InternalError(isRestricted.message());
    } else if isRestricted is boolean && isRestricted {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is restricted. Hence checking role permissions.");
        string[] allowedPermissions = [];
        foreach Role role in roles {
            foreach string permission in projectPermissions {
                ketoGrpcClient:CheckRequest checkRequest = {
                    tuple: {
                        namespace: constants:NAMESPACE_CHOREO_PROJECTS,
                        'object: org_uuid + constants:PATH_SEPARATOR + project_uuid,
                        relation: permission,
                        subject: {
                            set: {
                                namespace: constants:NAMESPACE_CHOREO_ROLES,
                                'object: org_uuid + constants:PATH_SEPARATOR + role.role_uuid,
                                relation: constants:RELATION_ROLE_HAS
                            }
                        }
                    }
                };
                ketoGrpcClient:CheckResponse|error? checkResponse = ketoGrpcClient:'check(checkRequest);
                if checkResponse is error {
                    log:printError("Organization [" + org_uuid + "] : Error while checking permission [" + permission + "] of project [" + project_uuid + "] for role [" + role.role_uuid + "]", checkResponse);
                    return error grpc:InternalError(checkResponse.message());
                } else if checkResponse is ketoGrpcClient:CheckResponse && checkResponse.allowed {
                    log:printDebug("Organization [" + org_uuid + "] : Role [" + role.role_uuid + "] has permission [" + permission + "] on project [" + project_uuid + "]");
                    allowedPermissions = addToAllowedPermissions(allowedPermissions, permission);
                } else {
                    log:printDebug("Organization [" + org_uuid + "] : Role [" + role.role_uuid + "] has isn't allowed permission [" + permission + "] on project [" + project_uuid + "]");
                }
            }
        }
        log:printDebug("Organization [" + org_uuid + "] : Returning project [" + project_uuid + "] with permissions " + allowedPermissions.toString());
        return {authorized: allowedPermissions.length() > 0, project_uuid: allowedPermissions.length() > 0 ? project_uuid : "", permissions: allowedPermissions};
    } else {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is not restricted. Hence returning project.");
        return {authorized: true, project_uuid: project_uuid, permissions: []};
    }
}

public function IsAllowedCreateProjects(ContextIsAllowedCreateProjectsRequest request) returns IsAllowedCreateProjectsResponse|error {
    return error("");
}

public function IsAllowedUpdateProject(ContextIsAllowedUpdateProjectRequest request) returns IsAllowedUpdateProjectResponse|error {
    var {project_uuid, roles, org_uuid} = request.content;
    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuid == "" {
        string err = "Organization [" + org_uuid + "] : Project UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    log:printDebug("Organization [" + org_uuid + "] : Starting to verify if update permissions of project : [" + project_uuid + "] is allowed for the given roles : [" + roles.toString() + "]");
    boolean|error? isRestricted = ketoGrpcClient:checkProjectRestricted(project_uuid, org_uuid);
    if isRestricted is error {
        log:printError("Organization [" + org_uuid + "] : Error while checking if the project is restricted when trying to update.", isRestricted);
        return error grpc:InternalError(isRestricted.message());
    } else if isRestricted is boolean && isRestricted {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is restricted. Hence checking update role permissions.");
        foreach Role role in roles {
            ketoGrpcClient:CheckRequest checkRequest = {
                tuple: {
                    namespace: constants:NAMESPACE_CHOREO_PROJECTS,
                    'object: org_uuid + "/" + project_uuid,
                    relation: constants:PERMISSION_PROJECT_MANAGE,
                    subject: {
                        set: {
                            namespace: constants:NAMESPACE_CHOREO_ROLES,
                            'object: org_uuid + "/" + role.role_uuid,
                            relation: constants:RELATION_ROLE_HAS
                        }
                    }
                }
            };
            ketoGrpcClient:CheckResponse|error? checkResponse = ketoGrpcClient:'check(checkRequest);
            if checkResponse is error {
                log:printError("Organization [" + org_uuid + "] : Error while checking permission [" + constants:PERMISSION_PROJECT_MANAGE + "] of project [" + project_uuid + "] for role [" + role.role_uuid + "]", checkResponse);
                return error grpc:InternalError(checkResponse.message());
            } else if checkResponse is ketoGrpcClient:CheckResponse && checkResponse.allowed {
                log:printDebug("Organization [" + org_uuid + "] : Update permission for project [" + project_uuid + "] allowed for role [" + role.role_uuid + "]");
                return {allowed: true};
            }
        }
    } else {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is not restricted. Hence allowing update.");
        return {allowed: true};
    }

    return {allowed: false};
}

public function IsAllowedPatchProject(ContextIsAllowedPatchProjectRequest request) returns IsAllowedPatchProjectResponse|error {
    var {project_uuid, roles, org_uuid} = request.content;
    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuid == "" {
        string err = "Organization [" + org_uuid + "] : Project UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    log:printDebug("Organization [" + org_uuid + "] : Starting to verify if patch permissions of project : [" + project_uuid + "] is allowed for the given roles : [" + roles.toString() + "]");
    boolean|error? isRestricted = ketoGrpcClient:checkProjectRestricted(project_uuid, org_uuid);
    if isRestricted is error {
        log:printError("Organization [" + org_uuid + "] : Error while checking if the project is restricted when trying to patch.", isRestricted);
        return error grpc:InternalError(isRestricted.message());
    } else if isRestricted is boolean && isRestricted {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is restricted. Hence checking patch role permissions.");
        foreach Role role in roles {
            ketoGrpcClient:CheckRequest checkRequest = {
                tuple: {
                    namespace: constants:NAMESPACE_CHOREO_PROJECTS,
                    'object: org_uuid + "/" + project_uuid,
                    relation: constants:PERMISSION_PROJECT_MANAGE,
                    subject: {
                        set: {
                            namespace: constants:NAMESPACE_CHOREO_ROLES,
                            'object: org_uuid + "/" + role.role_uuid,
                            relation: constants:RELATION_ROLE_HAS
                        }
                    }
                }
            };
            ketoGrpcClient:CheckResponse|error? checkResponse = ketoGrpcClient:'check(checkRequest);
            if checkResponse is error {
                log:printError("Organization [" + org_uuid + "] : Error while checking permission [" + constants:PERMISSION_PROJECT_MANAGE + "] of project [" + project_uuid + "] for role [" + role.role_uuid + "]", checkResponse);
                return error grpc:InternalError(checkResponse.message());
            } else if checkResponse is ketoGrpcClient:CheckResponse && checkResponse.allowed {
                log:printDebug("Organization [" + org_uuid + "] : Patch permission for project [" + project_uuid + "] allowed for role [" + role.role_uuid + "]");
                return {allowed: true};
            }
        }
    } else {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is not restricted. Hence allowing patch.");
        return {allowed: true};
    }

    return {allowed: false};
}

public function IsAllowedDeleteProject(ContextIsAllowedDeleteProjectRequest request) returns IsAllowedDeleteProjectResponse|error {
    var {project_uuid, roles, org_uuid} = request.content;
    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuid == "" {
        string err = "Organization [" + org_uuid + "] : Project UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    log:printDebug("Organization [" + org_uuid + "] : Starting to verify if delete permissions of project : [" + project_uuid + "] is allowed for the given roles : [" + roles.toString() + "]");
    boolean|error? isRestricted = ketoGrpcClient:checkProjectRestricted(project_uuid, org_uuid);
    if isRestricted is error {
        log:printError("Organization [" + org_uuid + "] : Error while checking if the project is restricted when trying to delete.", isRestricted);
        return error grpc:InternalError(isRestricted.message());
    } else if isRestricted is boolean && isRestricted {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is restricted. Hence checking delete role permissions.");
        foreach Role role in roles {
            ketoGrpcClient:CheckRequest checkRequest = {
                tuple: {
                    namespace: constants:NAMESPACE_CHOREO_PROJECTS,
                    'object: org_uuid + "/" + project_uuid,
                    relation: constants:PERMISSION_PROJECT_MANAGE,
                    subject: {
                        set: {
                            namespace: constants:NAMESPACE_CHOREO_ROLES,
                            'object: org_uuid + "/" + role.role_uuid,
                            relation: constants:RELATION_ROLE_HAS
                        }
                    }
                }
            };
            ketoGrpcClient:CheckResponse|error? checkResponse = ketoGrpcClient:'check(checkRequest);
            if checkResponse is error {
                log:printError("Organization [" + org_uuid + "] : Error while checking permission [" + constants:PERMISSION_PROJECT_MANAGE + "] of project [" + project_uuid + "] for role [" + role.role_uuid + "]", checkResponse);
                return error grpc:InternalError(checkResponse.message());
            } else if checkResponse is ketoGrpcClient:CheckResponse && checkResponse.allowed {
                log:printDebug("Organization [" + org_uuid + "] : Delete permission for project [" + project_uuid + "] allowed for role [" + role.role_uuid + "]");
                return {allowed: true};
            }
        }
    } else {
        log:printDebug("Organization [" + org_uuid + "] : Project [" + project_uuid + "] is not restricted. Hence allowing delete.");
        return {allowed: true};
    }

    return {allowed: false};
}

public function GetProjectShareInformation(ContextGetProjectShareInformationRequest request) returns GetProjectShareInformationResponse|error {
    var {project_uuid, org_uuid, editor_roles} = request.content;
    if org_uuid == "" {
        string err = "Organization UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if project_uuid == "" {
        string err = "Organization [" + org_uuid + "] : Project UUID cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }

    if editor_roles.length() <= 0 {
        string err = "Organization [" + org_uuid + "] : User role list cannot be empty";
        log:printError(err);
        return error grpc:InvalidArgumentError(err);
    }
    
    return error("");
}

public function UpdateProjectPermissions(ContextUpdateProjectPermissionsRequest request) returns UpdateProjectPermissionsResponse|error {
    return error("");
}
