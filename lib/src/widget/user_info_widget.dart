// import 'package:flutter/material.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import '../theme.dart';

// class UserInfoWidget extends StatelessWidget {
//   const UserInfoWidget({
//     Key key,
//     this.userProfile,
//     this.userEmail,
//     this.accessToken,
//     this.onSignOutPressed,
//     this.onLoginPressed
   
//   }) : super(key: key);

//   final UserProfile userProfile;
//   final String userEmail;
//   final StoredAccessToken accessToken;
//   final Function onSignOutPressed;
//   final Function onLoginPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           userProfile.pictureUrl.isNotEmpty
//               ? Image.network(
//                   userProfile.pictureUrl,
//                   width: 200,
//                   height: 200,
//                 )
//               : Icon(Icons.person),
//           Text(
//             userProfile.displayName,
//             style: Theme.of(context).textTheme.headline,
//           ),
//           if (userEmail != null) Text(userEmail),
        
//           Text(userProfile.statusMessage),
//              SizedBox(height: 10,),
//             Container(
//             child: RaisedButton(
//               textColor: textColor,
//               color: accentColor,
//               child: Text('ถัดไป'),
//               onPressed: onLoginPressed,
//             ),
//           ),
//           SizedBox(height: 10,),
//           Container(
//             child: RaisedButton(
//               textColor: textColor,
//               color: accentColor,
//               child: Text('Sign Out'),
//               onPressed: onSignOutPressed,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
