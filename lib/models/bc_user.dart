class BCUser {
  String? sId;
  String? idOrigen;
  String? names;
  String? lastNames;
  String? email;
  String? phone;
  String? address;
  Dimensions? dimensions;
  UserType? userType;
  String? createdAt;
  bool? isActive;
  bool? isArchived;
  bool? isInvited;
  List<Roles>? roles;
  bool? isRegistered;
  int? securityLevel;
  int? latitude;
  int? longitude;

  BCUser(
      {this.sId,
      this.idOrigen,
      this.names,
      this.lastNames,
      this.email,
      this.phone,
      this.address,
      this.dimensions,
      this.userType,
      this.createdAt,
      this.isActive,
      this.isArchived,
      this.isInvited,
      this.roles,
      this.isRegistered,
      this.securityLevel,
      this.latitude,
      this.longitude});

  BCUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idOrigen = json['idOrigen'];
    names = json['names'];
    lastNames = json['lastNames'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    dimensions = json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'])
        : null;
    userType =
        json['userType'] != null ? UserType.fromJson(json['userType']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    isArchived = json['isArchived'];
    isInvited = json['isInvited'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    isRegistered = json['isRegistered'];
    securityLevel = json['securityLevel'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['idOrigen'] = idOrigen;
    data['names'] = names;
    data['lastNames'] = lastNames;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    if (dimensions != null) {
      data['dimensions'] = dimensions!.toJson();
    }
    if (userType != null) {
      data['userType'] = userType!.toJson();
    }
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    data['isArchived'] = isArchived;
    data['isInvited'] = isInvited;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['isRegistered'] = isRegistered;
    data['securityLevel'] = securityLevel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Dimensions {
  String? dim1;
  String? dim2;
  String? dim3;
  String? dim4;
  String? dim5;
  String? dim6;
  String? dim7;
  String? dim8;
  String? dim9;
  String? dim10;

  Dimensions(
      {this.dim1,
      this.dim2,
      this.dim3,
      this.dim4,
      this.dim5,
      this.dim6,
      this.dim7,
      this.dim8,
      this.dim9,
      this.dim10});

  Dimensions.fromJson(Map<String, dynamic> json) {
    dim1 = json['dim1'];
    dim2 = json['dim2'];
    dim3 = json['dim3'];
    dim4 = json['dim4'];
    dim4 = json['dim5'];
    dim4 = json['dim6'];
    dim4 = json['dim7'];
    dim4 = json['dim8'];
    dim4 = json['dim9'];
    dim4 = json['dim10'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dim1'] = dim1;
    data['dim2'] = dim2;
    data['dim3'] = dim3;
    data['dim4'] = dim4;
    data['dim5'] = dim5;
    data['dim6'] = dim6;
    data['dim7'] = dim7;
    data['dim8'] = dim8;
    data['dim9'] = dim9;
    data['dim10'] = dim10;
    return data;
  }
}

class UserType {
  String? sId;
  String? name;
  String? catDimensions;

  UserType({this.sId, this.name, this.catDimensions});

  UserType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    catDimensions = json['catDimensions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['catDimensions'] = catDimensions;
    return data;
  }
}

class Roles {
  String? sId;
  String? name;
  bool? isActive;
  bool? isArchived;
  bool? isDefault;
  String? createdAt;

  Roles(
      {this.sId,
      this.name,
      this.isActive,
      this.isArchived,
      this.isDefault,
      this.createdAt});

  Roles.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    isArchived = json['isArchived'];
    isDefault = json['isDefault'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['isActive'] = isActive;
    data['isArchived'] = isArchived;
    data['isDefault'] = isDefault;
    data['createdAt'] = createdAt;
    return data;
  }
}

class AuthUser {
  BCUser? user;
  String? userKey;

  AuthUser({this.user, this.userKey});

  AuthUser.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? BCUser.fromJson(json['user']) : null;
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user?.toJson();
    data['userKey'] = userKey;
    return data;
  }
}

class AuthUserCode {
  BCUser? user;
  String? userKey;
  String? accessToken;

  AuthUserCode({this.user, this.userKey, this.accessToken});

  AuthUserCode.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? BCUser.fromJson(json['user']) : null;
    userKey = json['userKey'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user?.toJson();
    data['userKey'] = userKey;
    data['accessToken'] = accessToken;
    return data;
  }
}
