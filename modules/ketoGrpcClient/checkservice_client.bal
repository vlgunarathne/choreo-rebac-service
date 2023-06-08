import authz_service.constants;
import authz_service.config;

// CheckServiceClient checkServiceClient = check new ("http://localhost:4466");
CheckServiceClient checkServiceClient = check new (config:ketoHttpScheme+"://"+config:ketoHostnameRead+":"+config:ketoReadPort.toString());
# Description
#
# + checkRequest - Parameter Description
# + return - Return Value Description
public function 'check(CheckRequest checkRequest) returns CheckResponse|error {
    CheckResponse checkResponse = check checkServiceClient->Check(checkRequest);
    return checkResponse;
}

# Description
#
# + project_uuid - Parameter Description  
# + org_uuid - Parameter Description
# + return - Return Value Description
public function checkProjectRestricted(string project_uuid, string org_uuid) returns boolean|error? {
    CheckRequest request = {
        tuple: {
            namespace: constants:NAMESPACE_CHOREO_PROJECTS,
            'object: org_uuid + constants:PATH_SEPARATOR + project_uuid,
            relation: constants:PERMISSION_PROJECT_ACCESS,
            subject: {
                id: constants:SUBJECT_RESTRICTED
            }
        }
    };
    CheckResponse response = check 'check(request);
    return response.allowed;
}
