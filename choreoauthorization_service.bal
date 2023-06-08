import ballerina/grpc;
import authz_service.authz;
import authz_service.config;

listener grpc:Listener ep = new (config:grpcApiPort);

@grpc:Descriptor {value: authz:CHOREO_AUTHORIZATION_DESC}
service "ChoreoAuthorization" on ep {

    remote function GetAuthorizedProjectList(authz:ContextGetAuthorizedProjectListRequest value) returns authz:GetAuthorizedProjectListResponse|error {
        return authz:GetAuthorizedProjectList(value);
    }

    remote function GetAuthorizedProject(authz:ContextGetAuthorizedProjectRequest value) returns authz:GetAuthorizedProjectResponse|error {
        return authz:GetAuthorizedProject(value);
    }
    remote function IsAllowedCreateProjects(authz:ContextIsAllowedCreateProjectsRequest value) returns authz:IsAllowedCreateProjectsResponse|error {
        return authz:IsAllowedCreateProjects(value);
    }
    remote function IsAllowedUpdateProject(authz:ContextIsAllowedUpdateProjectRequest value) returns authz:IsAllowedUpdateProjectResponse|error {
        return authz:IsAllowedUpdateProject(value);
    }
    remote function IsAllowedPatchProject(authz:ContextIsAllowedPatchProjectRequest value) returns authz:IsAllowedPatchProjectResponse|error {
        return authz:IsAllowedPatchProject(value);
    }
    remote function IsAllowedDeleteProject(authz:ContextIsAllowedDeleteProjectRequest value) returns authz:IsAllowedDeleteProjectResponse|error {
        return authz:IsAllowedDeleteProject(value);
    }
    remote function GetProjectShareInformation(authz:ContextGetProjectShareInformationRequest value) returns authz:GetProjectShareInformationResponse|error {
        return authz:GetProjectShareInformation(value);
    }
    remote function UpdateProjectPermissions(authz:ContextUpdateProjectPermissionsRequest value) returns authz:UpdateProjectPermissionsResponse|error {
        return authz:UpdateProjectPermissions(value);
    }
}

