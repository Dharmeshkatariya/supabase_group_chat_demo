import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:supabase_app_demo/app/modules/chat/widget/painter_widget.dart';

import '../../../../models/Message.dart';
import '../../../../utils/export.dart';
import 'forward/forward_message_header_widget.dart';
import 'message_status.dart';

// Widget receivedMessage(
//     {required BuildContext context, required Message message}) {
//   final messageTextGroup = Flexible(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.rotationY(math.pi),
//           child: CustomPaint(
//             painter: Triangle(Colors.grey[300]!),
//           ),
//         ),
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(18),
//                 bottomLeft: Radius.circular(18),
//                 bottomRight: Radius.circular(18),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // if (widget.message.chatRoomId != widget.message.forwardedFrom)
//                     //   ForwardedMessageHeader(
//                     //     originalMessageId: widget.message.originalMessageId!,
//                     //     forwardedFrom: widget.message.forwardedFrom!,
//                     //   ),
//                     //
//                     // if (widget.message.chatRoomId != widget.message.forwardedFrom)
//                     //   5.verticalSpace ,
//                     //
//                     if (widget.senderInfo != null && receiverUser)
//                       Text(
//                         widget.senderInfo!.name!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.black54,
//                         ),
//                       ),
//                     if (widget.message.mtype == MessageType.image)
//                       GestureDetector(
//                         onTap: () {},
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: InstaImageViewer(
//                             child: CachedNetworkImage(
//                               imageUrl: getS3Url(message.message!),
//                               placeholder: (context, url) =>
//                                   Utility.imageLoader(),
//                               height: 200.h,
//                               width: 200.w,
//                               fit: BoxFit.cover,
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (widget.message.mtype == MessageType.text)
//                       Text(
//                         message.message,
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontFamily: 'Monstserrat',
//                             fontSize: 14),
//                       ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     2.verticalSpace,
//                     if (widget.message.iAmNotTheSender ||
//                         !widget.message.hasPendingWrites) ...[
//                       Text(
//                         DateFormat('HH:mm').format(widget.message.sentAt!),
//                         style: TextStyle(
//                           color: receiverUser
//                               ? Colors.grey[500]
//                               : Colors.green[50],
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
//
//   return Padding(
//     padding: const EdgeInsets.only(right: 50.0, left: 8, top: 5, bottom: 5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             const SizedBox(height: 30),
//             messageTextGroup,
//           ],
//         ),
//         buildReactions(
//           isMe,
//         ),
//       ],
//     ),
//   );
// }

// Widget sendMessage(
//     {required BuildContext context, required Message message}) {
//   final messageTextGroup = Flexible(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(18),
//                 bottomLeft: Radius.circular(18),
//                 bottomRight: Radius.circular(18),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (widget.message.forwardedFrom != null &&
//                         widget.message.chatRoomId !=
//                             widget.message.forwardedFrom &&
//                         widget.message.isForwarded) ...[
//                       ForwardedMessageHeader(
//                         originalMessageId: widget.message.originalMessageId!,
//                         forwardedFrom: widget.message.forwardedFrom!,
//                       ),
//                       5.verticalSpace,
//                     ],
//                     if (widget.message.mtype == MessageType.image)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: InstaImageViewer(
//                           child: CachedNetworkImage(
//                             imageUrl: getS3Url(message.message!),
//                             placeholder: (context, url) =>
//                                 Utility.imageLoader(),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           ),
//                         ),
//                       ),
//                     if (widget.message.mtype == MessageType.text)
//                       Text(
//                         message.message,
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Monstserrat',
//                             fontSize: 14),
//                       ),
//                     if (widget.message.hasPendingWrites)
//                       const SizedBox(height: 2),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     2.verticalSpace,
//                     if (widget.message.iAmNotTheSender ||
//                         !widget.message.hasPendingWrites) ...[
//                       Text(
//                         DateFormat('HH:mm').format(widget.message.createdAt),
//                         style: TextStyle(
//                           color: receiverUser
//                               ? Colors.grey[500]
//                               : Colors.green[50],
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                     ],
//                     2.horizontalSpace,
//                     if (!receiverUser)
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 2),
//                           child: messageStatus(message: widget.message),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         CustomPaint(painter: Triangle(Colors.grey[900]!)),
//       ],
//     ),
//   );
//
//   return Padding(
//     padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             const SizedBox(height: 30),
//             messageTextGroup,
//           ],
//         ),
//         buildReactions(
//           isMe,
//         ),
//       ],
//     ),
//   );
// }
// Widget _replySendMessage({
//   required BuildContext context,
//   required Message message,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(18),
//               bottomLeft: Radius.circular(18),
//               bottomRight: Radius.circular(18),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               buildReplyMessage(),
//               if (message.forwardedFrom != null &&
//                   message.chatRoomId != message.forwardedFrom &&
//                   message.isForwarded) ...[
//                 ForwardedMessageHeader(
//                   originalMessageId: message.originalMessageId!,
//                   forwardedFrom: message.forwardedFrom!,
//                 ),
//                 const SizedBox(height: 5),
//               ],
//               if (message.mtype == MessageType.image) ...[
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: InstaImageViewer(
//                     child: CachedNetworkImage(
//                       imageUrl: getS3Url(message.message),
//                       placeholder: (context, url) => Utility.imageLoader(),
//                       errorWidget: (context, url, error) =>
//                       const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//               ],
//               if (message.mtype == MessageType.text) ...[
//                 Text(
//                   message.message,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'Montserrat',
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//               ],
//               if (message.hasPendingWrites) const SizedBox(height: 2),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (message.iAmNotTheSender ||
//                       !message.hasPendingWrites) ...[
//                     Text(
//                       DateFormat('HH:mm').format(message.createdAt),
//                       style: TextStyle(
//                         color: receiverUser
//                             ? Colors.grey[500]
//                             : Colors.green[50],
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 2),
//                   ],
//                   if (!receiverUser)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 2),
//                       child: messageStatus(message: message),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             buildReactions(isMe),
//           ],
//         )
//       ],
//     ),
//   );
// }
