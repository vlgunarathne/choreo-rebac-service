import ballerina/grpc;
import ballerina/protobuf;

public const string CHECK_SERVICE_DESC = "0A13636865636B5F736572766963652E70726F746F12216F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C7068613222D1020A0C436865636B5265717565737412200A096E616D6573706163651801200128094202180152096E616D657370616365121A0A066F626A6563741802200128094202180152066F626A656374121E0A0872656C6174696F6E18032001280942021801520872656C6174696F6E12480A077375626A65637418042001280B322A2E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E5375626A6563744202180152077375626A65637412460A057475706C6518082001280B32302E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E52656C6174696F6E5475706C6552057475706C6512160A066C617465737418052001280852066C6174657374121C0A09736E6170746F6B656E1806200128095209736E6170746F6B656E121B0A096D61785F646570746818072001280552086D6178446570746822470A0D436865636B526573706F6E736512180A07616C6C6F7765641801200128085207616C6C6F776564121C0A09736E6170746F6B656E1802200128095209736E6170746F6B656E22A7010A0D52656C6174696F6E5475706C65121C0A096E616D65737061636518012001280952096E616D65737061636512160A066F626A65637418022001280952066F626A656374121A0A0872656C6174696F6E180320012809520872656C6174696F6E12440A077375626A65637418042001280B322A2E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E5375626A65637452077375626A65637422650A075375626A65637412100A02696418012001280948005202696412410A0373657418022001280B322D2E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E5375626A6563745365744800520373657442050A03726566225E0A0A5375626A656374536574121C0A096E616D65737061636518012001280952096E616D65737061636512160A066F626A65637418022001280952066F626A656374121A0A0872656C6174696F6E180320012809520872656C6174696F6E327A0A0C436865636B53657276696365126A0A05436865636B122F2E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E436865636B526571756573741A302E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861322E436865636B526573706F6E736542C2010A2473682E6F72792E6B65746F2E72656C6174696F6E5F7475706C65732E7631616C706861324211436865636B5365727669636550726F746F50015A3F6769746875622E636F6D2F6F72792F6B65746F2F70726F746F2F6F72792F6B65746F2F72656C6174696F6E5F7475706C65732F7631616C706861323B727473AA02204F72792E4B65746F2E52656C6174696F6E5475706C65732E7631616C70686132CA02204F72795C4B65746F5C52656C6174696F6E5475706C65735C7631616C70686132620670726F746F33";

public isolated client class CheckServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CHECK_SERVICE_DESC);
    }

    isolated remote function Check(CheckRequest|ContextCheckRequest req) returns CheckResponse|grpc:Error {
        map<string|string[]> headers = {};
        CheckRequest message;
        if req is ContextCheckRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ory.keto.relation_tuples.v1alpha2.CheckService/Check", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CheckResponse>result;
    }

    isolated remote function CheckContext(CheckRequest|ContextCheckRequest req) returns ContextCheckResponse|grpc:Error {
        map<string|string[]> headers = {};
        CheckRequest message;
        if req is ContextCheckRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ory.keto.relation_tuples.v1alpha2.CheckService/Check", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CheckResponse>result, headers: respHeaders};
    }
}

public type ContextCheckResponse record {|
    CheckResponse content;
    map<string|string[]> headers;
|};

public type ContextCheckRequest record {|
    CheckRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CHECK_SERVICE_DESC}
public type RelationTuple record {|
    string namespace = "";
    string 'object = "";
    string relation = "";
    Subject subject = {};
|};

@protobuf:Descriptor {value: CHECK_SERVICE_DESC}
public type SubjectSet record {|
    string namespace = "";
    string 'object = "";
    string relation = "";
|};

@protobuf:Descriptor {value: CHECK_SERVICE_DESC}
public type CheckResponse record {|
    boolean allowed = false;
    string snaptoken = "";
|};

@protobuf:Descriptor {value: CHECK_SERVICE_DESC}
public type CheckRequest record {|
    string namespace = "";
    string 'object = "";
    string relation = "";
    Subject subject = {};
    RelationTuple tuple = {};
    boolean latest = false;
    string snaptoken = "";
    int max_depth = 0;
|};

@protobuf:Descriptor {value: CHECK_SERVICE_DESC}
public type Subject record {|
    string id?;
    SubjectSet set?;
|};

isolated function isValidSubject(Subject r) returns boolean {
    int refCount = 0;
    if !(r?.id is ()) {
        refCount += 1;
    }
    if !(r?.set is ()) {
        refCount += 1;
    }
    if (refCount > 1) {
        return false;
    }
    return true;
}

isolated function setSubject_Id(Subject r, string id) {
    r.id = id;
    _ = r.removeIfHasKey("set");
}

isolated function setSubject_Set(Subject r, SubjectSet set) {
    r.set = set;
    _ = r.removeIfHasKey("id");
}

