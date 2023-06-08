// Service configs
public configurable int grpcApiPort = 9090;

// Keto configs
public configurable int ketoReadPort = 4466;
public configurable int ketoWritePort = 4467;
public configurable string ketoHostnameRead = "localhost";
public configurable string ketoHostnameWrite = "localhost";
public configurable string ketoGrpcScheme = "grpc";
public configurable string ketoHttpScheme = "http";

// Permissions
public configurable string[] projectPermissions = ["view", "manage"];