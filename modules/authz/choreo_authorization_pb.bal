import ballerina/grpc;
import ballerina/protobuf;

public const string CHOREO_AUTHORIZATION_DESC = "0A1A63686F72656F5F617574686F72697A6174696F6E2E70726F746F1211617574687A2E63686F72656F2E617069732290010A1F476574417574686F72697A656450726F6A6563744C6973745265717565737412230A0D70726F6A6563745F7575696473180120032809520C70726F6A6563745575696473122D0A05726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418032001280952076F726755756964225A0A20476574417574686F72697A656450726F6A6563744C697374526573706F6E736512360A0870726F6A6563747318012003280B321A2E617574687A2E63686F72656F2E617069732E50726F6A656374520870726F6A65637473228A010A1B476574417574686F72697A656450726F6A6563745265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964122D0A05726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418032001280952076F7267557569642283010A1C476574417574686F72697A656450726F6A656374526573706F6E7365121E0A0A617574686F72697A6564180120012808520A617574686F72697A656412210A0C70726F6A6563745F75756964180220012809520B70726F6A6563745575696412200A0B7065726D697373696F6E73180320032809520B7065726D697373696F6E73226A0A1E4973416C6C6F77656443726561746550726F6A6563747352657175657374122D0A05726F6C657318012003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418022001280952076F726755756964223B0A1F4973416C6C6F77656443726561746550726F6A65637473526573706F6E736512180A07616C6C6F7765641801200128085207616C6C6F776564228C010A1D4973416C6C6F77656455706461746550726F6A6563745265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964122D0A05726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418032001280952076F726755756964223A0A1E4973416C6C6F77656455706461746550726F6A656374526573706F6E736512180A07616C6C6F7765641801200128085207616C6C6F776564228B010A1C4973416C6C6F776564506174636850726F6A6563745265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964122D0A05726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418032001280952076F72675575696422390A1D4973416C6C6F776564506174636850726F6A656374526573706F6E736512180A07616C6C6F7765641801200128085207616C6C6F776564228C010A1D4973416C6C6F77656444656C65746550726F6A6563745265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964122D0A05726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C655205726F6C657312190A086F72675F7575696418032001280952076F726755756964223A0A1E4973416C6C6F77656444656C65746550726F6A656374526573706F6E736512180A07616C6C6F7765641801200128085207616C6C6F776564229D010A2147657450726F6A6563745368617265496E666F726D6174696F6E5265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A6563745575696412190A086F72675F7575696418022001280952076F726755756964123A0A0C656469746F725F726F6C657318032003280B32172E617574687A2E63686F72656F2E617069732E526F6C65520B656469746F72526F6C65732296010A2247657450726F6A6563745368617265496E666F726D6174696F6E526573706F6E736512210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964124D0A10726F6C655F7065726D697373696F6E7318022003280B32222E617574687A2E63686F72656F2E617069732E526F6C655065726D697373696F6E73520F726F6C655065726D697373696F6E7322FA010A1F55706461746550726F6A6563745065726D697373696F6E735265717565737412210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964123A0A0C656469746F725F726F6C657318022003280B32172E617574687A2E63686F72656F2E617069732E526F6C65520B656469746F72526F6C657312340A096E65775F726F6C657318032003280B32172E617574687A2E63686F72656F2E617069732E526F6C6552086E6577526F6C657312270A0F6E65775F7065726D697373696F6E73180420032809520E6E65775065726D697373696F6E7312190A086F72675F7575696418052001280952076F7267557569642294010A2055706461746550726F6A6563745065726D697373696F6E73526573706F6E736512210A0C70726F6A6563745F75756964180120012809520B70726F6A65637455756964124D0A10726F6C655F7065726D697373696F6E7318022003280B32222E617574687A2E63686F72656F2E617069732E526F6C655065726D697373696F6E73520F726F6C655065726D697373696F6E73222C0A0750726F6A65637412210A0C70726F6A6563745F75756964180120012809520B70726F6A6563745575696422230A04526F6C65121B0A09726F6C655F757569641801200128095208726F6C655575696422600A0F526F6C655065726D697373696F6E73122B0A04726F6C6518012001280B32172E617574687A2E63686F72656F2E617069732E526F6C655204726F6C6512200A0B7065726D697373696F6E73180220032809520B7065726D697373696F6E7332B3080A1343686F72656F417574686F72697A6174696F6E1285010A18476574417574686F72697A656450726F6A6563744C69737412322E617574687A2E63686F72656F2E617069732E476574417574686F72697A656450726F6A6563744C697374526571756573741A332E617574687A2E63686F72656F2E617069732E476574417574686F72697A656450726F6A6563744C697374526573706F6E7365220012790A14476574417574686F72697A656450726F6A656374122E2E617574687A2E63686F72656F2E617069732E476574417574686F72697A656450726F6A656374526571756573741A2F2E617574687A2E63686F72656F2E617069732E476574417574686F72697A656450726F6A656374526573706F6E736522001282010A174973416C6C6F77656443726561746550726F6A6563747312312E617574687A2E63686F72656F2E617069732E4973416C6C6F77656443726561746550726F6A65637473526571756573741A322E617574687A2E63686F72656F2E617069732E4973416C6C6F77656443726561746550726F6A65637473526573706F6E73652200127F0A164973416C6C6F77656455706461746550726F6A65637412302E617574687A2E63686F72656F2E617069732E4973416C6C6F77656455706461746550726F6A656374526571756573741A312E617574687A2E63686F72656F2E617069732E4973416C6C6F77656455706461746550726F6A656374526573706F6E73652200127C0A154973416C6C6F776564506174636850726F6A656374122F2E617574687A2E63686F72656F2E617069732E4973416C6C6F776564506174636850726F6A656374526571756573741A302E617574687A2E63686F72656F2E617069732E4973416C6C6F776564506174636850726F6A656374526573706F6E73652200127F0A164973416C6C6F77656444656C65746550726F6A65637412302E617574687A2E63686F72656F2E617069732E4973416C6C6F77656444656C65746550726F6A656374526571756573741A312E617574687A2E63686F72656F2E617069732E4973416C6C6F77656444656C65746550726F6A656374526573706F6E73652200128B010A1A47657450726F6A6563745368617265496E666F726D6174696F6E12342E617574687A2E63686F72656F2E617069732E47657450726F6A6563745368617265496E666F726D6174696F6E526571756573741A352E617574687A2E63686F72656F2E617069732E47657450726F6A6563745368617265496E666F726D6174696F6E526573706F6E736522001285010A1855706461746550726F6A6563745065726D697373696F6E7312322E617574687A2E63686F72656F2E617069732E55706461746550726F6A6563745065726D697373696F6E73526571756573741A332E617574687A2E63686F72656F2E617069732E55706461746550726F6A6563745065726D697373696F6E73526573706F6E73652200620670726F746F33";

public isolated client class ChoreoAuthorizationClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CHOREO_AUTHORIZATION_DESC);
    }

    isolated remote function GetAuthorizedProjectList(GetAuthorizedProjectListRequest|ContextGetAuthorizedProjectListRequest req) returns GetAuthorizedProjectListResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetAuthorizedProjectListRequest message;
        if req is ContextGetAuthorizedProjectListRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetAuthorizedProjectList", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetAuthorizedProjectListResponse>result;
    }

    isolated remote function GetAuthorizedProjectListContext(GetAuthorizedProjectListRequest|ContextGetAuthorizedProjectListRequest req) returns ContextGetAuthorizedProjectListResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetAuthorizedProjectListRequest message;
        if req is ContextGetAuthorizedProjectListRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetAuthorizedProjectList", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetAuthorizedProjectListResponse>result, headers: respHeaders};
    }

    isolated remote function GetAuthorizedProject(GetAuthorizedProjectRequest|ContextGetAuthorizedProjectRequest req) returns GetAuthorizedProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetAuthorizedProjectRequest message;
        if req is ContextGetAuthorizedProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetAuthorizedProject", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetAuthorizedProjectResponse>result;
    }

    isolated remote function GetAuthorizedProjectContext(GetAuthorizedProjectRequest|ContextGetAuthorizedProjectRequest req) returns ContextGetAuthorizedProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetAuthorizedProjectRequest message;
        if req is ContextGetAuthorizedProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetAuthorizedProject", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetAuthorizedProjectResponse>result, headers: respHeaders};
    }

    isolated remote function IsAllowedCreateProjects(IsAllowedCreateProjectsRequest|ContextIsAllowedCreateProjectsRequest req) returns IsAllowedCreateProjectsResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedCreateProjectsRequest message;
        if req is ContextIsAllowedCreateProjectsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedCreateProjects", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <IsAllowedCreateProjectsResponse>result;
    }

    isolated remote function IsAllowedCreateProjectsContext(IsAllowedCreateProjectsRequest|ContextIsAllowedCreateProjectsRequest req) returns ContextIsAllowedCreateProjectsResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedCreateProjectsRequest message;
        if req is ContextIsAllowedCreateProjectsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedCreateProjects", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <IsAllowedCreateProjectsResponse>result, headers: respHeaders};
    }

    isolated remote function IsAllowedUpdateProject(IsAllowedUpdateProjectRequest|ContextIsAllowedUpdateProjectRequest req) returns IsAllowedUpdateProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedUpdateProjectRequest message;
        if req is ContextIsAllowedUpdateProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedUpdateProject", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <IsAllowedUpdateProjectResponse>result;
    }

    isolated remote function IsAllowedUpdateProjectContext(IsAllowedUpdateProjectRequest|ContextIsAllowedUpdateProjectRequest req) returns ContextIsAllowedUpdateProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedUpdateProjectRequest message;
        if req is ContextIsAllowedUpdateProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedUpdateProject", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <IsAllowedUpdateProjectResponse>result, headers: respHeaders};
    }

    isolated remote function IsAllowedPatchProject(IsAllowedPatchProjectRequest|ContextIsAllowedPatchProjectRequest req) returns IsAllowedPatchProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedPatchProjectRequest message;
        if req is ContextIsAllowedPatchProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedPatchProject", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <IsAllowedPatchProjectResponse>result;
    }

    isolated remote function IsAllowedPatchProjectContext(IsAllowedPatchProjectRequest|ContextIsAllowedPatchProjectRequest req) returns ContextIsAllowedPatchProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedPatchProjectRequest message;
        if req is ContextIsAllowedPatchProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedPatchProject", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <IsAllowedPatchProjectResponse>result, headers: respHeaders};
    }

    isolated remote function IsAllowedDeleteProject(IsAllowedDeleteProjectRequest|ContextIsAllowedDeleteProjectRequest req) returns IsAllowedDeleteProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedDeleteProjectRequest message;
        if req is ContextIsAllowedDeleteProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedDeleteProject", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <IsAllowedDeleteProjectResponse>result;
    }

    isolated remote function IsAllowedDeleteProjectContext(IsAllowedDeleteProjectRequest|ContextIsAllowedDeleteProjectRequest req) returns ContextIsAllowedDeleteProjectResponse|grpc:Error {
        map<string|string[]> headers = {};
        IsAllowedDeleteProjectRequest message;
        if req is ContextIsAllowedDeleteProjectRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/IsAllowedDeleteProject", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <IsAllowedDeleteProjectResponse>result, headers: respHeaders};
    }

    isolated remote function GetProjectShareInformation(GetProjectShareInformationRequest|ContextGetProjectShareInformationRequest req) returns GetProjectShareInformationResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetProjectShareInformationRequest message;
        if req is ContextGetProjectShareInformationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetProjectShareInformation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetProjectShareInformationResponse>result;
    }

    isolated remote function GetProjectShareInformationContext(GetProjectShareInformationRequest|ContextGetProjectShareInformationRequest req) returns ContextGetProjectShareInformationResponse|grpc:Error {
        map<string|string[]> headers = {};
        GetProjectShareInformationRequest message;
        if req is ContextGetProjectShareInformationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/GetProjectShareInformation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetProjectShareInformationResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProjectPermissions(UpdateProjectPermissionsRequest|ContextUpdateProjectPermissionsRequest req) returns UpdateProjectPermissionsResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProjectPermissionsRequest message;
        if req is ContextUpdateProjectPermissionsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/UpdateProjectPermissions", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateProjectPermissionsResponse>result;
    }

    isolated remote function UpdateProjectPermissionsContext(UpdateProjectPermissionsRequest|ContextUpdateProjectPermissionsRequest req) returns ContextUpdateProjectPermissionsResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProjectPermissionsRequest message;
        if req is ContextUpdateProjectPermissionsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("authz.choreo.apis.ChoreoAuthorization/UpdateProjectPermissions", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateProjectPermissionsResponse>result, headers: respHeaders};
    }
}

public client class ChoreoAuthorizationIsAllowedUpdateProjectResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendIsAllowedUpdateProjectResponse(IsAllowedUpdateProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextIsAllowedUpdateProjectResponse(ContextIsAllowedUpdateProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationIsAllowedPatchProjectResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendIsAllowedPatchProjectResponse(IsAllowedPatchProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextIsAllowedPatchProjectResponse(ContextIsAllowedPatchProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationIsAllowedCreateProjectsResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendIsAllowedCreateProjectsResponse(IsAllowedCreateProjectsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextIsAllowedCreateProjectsResponse(ContextIsAllowedCreateProjectsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationUpdateProjectPermissionsResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUpdateProjectPermissionsResponse(UpdateProjectPermissionsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUpdateProjectPermissionsResponse(ContextUpdateProjectPermissionsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationIsAllowedDeleteProjectResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendIsAllowedDeleteProjectResponse(IsAllowedDeleteProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextIsAllowedDeleteProjectResponse(ContextIsAllowedDeleteProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationGetProjectShareInformationResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetProjectShareInformationResponse(GetProjectShareInformationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetProjectShareInformationResponse(ContextGetProjectShareInformationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationGetAuthorizedProjectResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetAuthorizedProjectResponse(GetAuthorizedProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetAuthorizedProjectResponse(ContextGetAuthorizedProjectResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ChoreoAuthorizationGetAuthorizedProjectListResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetAuthorizedProjectListResponse(GetAuthorizedProjectListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetAuthorizedProjectListResponse(ContextGetAuthorizedProjectListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextGetAuthorizedProjectListResponse record {|
    GetAuthorizedProjectListResponse content;
    map<string|string[]> headers;
|};

public type ContextGetAuthorizedProjectResponse record {|
    GetAuthorizedProjectResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateProjectPermissionsResponse record {|
    UpdateProjectPermissionsResponse content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedPatchProjectRequest record {|
    IsAllowedPatchProjectRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateProjectPermissionsRequest record {|
    UpdateProjectPermissionsRequest content;
    map<string|string[]> headers;
|};

public type ContextGetAuthorizedProjectRequest record {|
    GetAuthorizedProjectRequest content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedUpdateProjectRequest record {|
    IsAllowedUpdateProjectRequest content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedCreateProjectsRequest record {|
    IsAllowedCreateProjectsRequest content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedCreateProjectsResponse record {|
    IsAllowedCreateProjectsResponse content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedDeleteProjectResponse record {|
    IsAllowedDeleteProjectResponse content;
    map<string|string[]> headers;
|};

public type ContextGetProjectShareInformationRequest record {|
    GetProjectShareInformationRequest content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedPatchProjectResponse record {|
    IsAllowedPatchProjectResponse content;
    map<string|string[]> headers;
|};

public type ContextGetProjectShareInformationResponse record {|
    GetProjectShareInformationResponse content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedUpdateProjectResponse record {|
    IsAllowedUpdateProjectResponse content;
    map<string|string[]> headers;
|};

public type ContextGetAuthorizedProjectListRequest record {|
    GetAuthorizedProjectListRequest content;
    map<string|string[]> headers;
|};

public type ContextIsAllowedDeleteProjectRequest record {|
    IsAllowedDeleteProjectRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetAuthorizedProjectListResponse record {|
    Project[] projects = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetAuthorizedProjectResponse record {|
    boolean authorized = false;
    string project_uuid = "";
    string[] permissions = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type UpdateProjectPermissionsResponse record {|
    string project_uuid = "";
    RolePermissions[] role_permissions = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type RolePermissions record {|
    Role role = {};
    string[] permissions = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedPatchProjectRequest record {|
    string project_uuid = "";
    Role[] roles = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type UpdateProjectPermissionsRequest record {|
    string project_uuid = "";
    Role[] editor_roles = [];
    Role[] new_roles = [];
    string[] new_permissions = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetAuthorizedProjectRequest record {|
    string project_uuid = "";
    Role[] roles = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedUpdateProjectRequest record {|
    string project_uuid = "";
    Role[] roles = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedCreateProjectsRequest record {|
    Role[] roles = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type Role record {|
    string role_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type Project record {|
    string project_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedCreateProjectsResponse record {|
    boolean allowed = false;
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedDeleteProjectResponse record {|
    boolean allowed = false;
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetProjectShareInformationRequest record {|
    string project_uuid = "";
    string org_uuid = "";
    Role[] editor_roles = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedPatchProjectResponse record {|
    boolean allowed = false;
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetProjectShareInformationResponse record {|
    string project_uuid = "";
    RolePermissions[] role_permissions = [];
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedUpdateProjectResponse record {|
    boolean allowed = false;
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type GetAuthorizedProjectListRequest record {|
    string[] project_uuids = [];
    Role[] roles = [];
    string org_uuid = "";
|};

@protobuf:Descriptor {value: CHOREO_AUTHORIZATION_DESC}
public type IsAllowedDeleteProjectRequest record {|
    string project_uuid = "";
    Role[] roles = [];
    string org_uuid = "";
|};

