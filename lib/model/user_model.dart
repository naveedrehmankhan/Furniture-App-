class UserModel {

  
  String? uid;
  String? email;
  String? username;
  String? password;
  String? joinDate;
  String? actualTime;
  String? status;
  bool is_Verified;
  
 

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.password,
    this.joinDate,
    this.actualTime,
    this.status,
    this.is_Verified = false
  
   
  });

  // Receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
      joinDate: map['joindate'],
      actualTime: map['actualtime'],
       status: map['status'],
      is_Verified: map['is_verified'] ?? false,
     
    
    );
  }

  // Sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'password': password,
      'joindate':joinDate,
      'actualtime':actualTime,
      'status': status,
      'is_verified':is_Verified,
      
     
    };
  }
}
