import authz_service.config;
public function getProjectPermissions() returns string[] {
    return config:projectPermissions;
}

public function addToAllowedPermissions(string[] allowedPermissions, string newPermission) returns string[] {
    if allowedPermissions.indexOf(newPermission) == () {
        allowedPermissions.push(newPermission);
    }
    return allowedPermissions;
}