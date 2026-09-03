import 'package:momaspayplus/features/support/data/models/chat_message.dart';

final Map<String, List<ChatMessage>> mockMessages = {
  '#00142': const [
    ChatMessage(
      text: 'I am unable to complete my transfer. The transaction keeps failing at the confirmation step.',
      timeAgo: '3 mins ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Kindly confirm that you punched the right token and also provide me with the token used and your meter number so I can assist you further.',
      timeAgo: '5 secs ago',
      isSender: false,
    ),
  ],
  '#00139': const [
    ChatMessage(
      text: 'My account was debited twice for the same transaction on the 18th of May. Same reference, same amount NGN 45,000, same timestamp. I need the duplicate charge reversed immediately.',
      timeAgo: '2 hrs ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'We are sorry to hear this. Could you please share the transaction reference number so we can investigate?',
      timeAgo: '1 hr ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'The reference number is TXN-2026051800445.',
      timeAgo: '58 mins ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Thank you. We have escalated this to our payments team and a reversal will be processed within 24 hours.',
      timeAgo: '45 mins ago',
      isSender: false,
    ),
  ],
  '#00131': const [
    ChatMessage(
      text: 'Unable to log in after resetting my password. The new password is not being accepted on the mobile app.',
      timeAgo: '1 day ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Please try clearing the app cache and attempt login again. If the issue persists, try uninstalling and reinstalling the app.',
      timeAgo: '23 hrs ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'That worked! I can log in now. Thank you.',
      timeAgo: '22 hrs ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Issue has been resolved. I will be closing this ticket now.',
      timeAgo: '22 hrs ago',
      isSender: false,
    ),
  ],
  '#00128': const [
    ChatMessage(
      text: 'My prepaid meter is not reflecting the units I purchased yesterday. I bought 50 units but the meter still shows the same balance.',
      timeAgo: '2 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Please provide your meter number and the token you received so we can verify the transaction on our end.',
      timeAgo: '2 days ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'Meter: 04512367890. Token: 2145639770123456789.',
      timeAgo: '2 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'We have confirmed the token was valid and re-pushed the units to your meter. Please check your meter balance now.',
      timeAgo: '1 day ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'The units are now showing. Thank you!',
      timeAgo: '1 day ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Issue has been resolved. I will be closing this ticket now.',
      timeAgo: '1 day ago',
      isSender: false,
    ),
  ],
  '#00120': const [
    ChatMessage(
      text: 'I was charged a transaction fee that was not disclosed before I confirmed the payment. I want a full refund of the hidden charge.',
      timeAgo: '3 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'We apologize for the inconvenience. Could you share the transaction ID and the amount charged so we can review this?',
      timeAgo: '3 days ago',
      isSender: false,
    ),
  ],
  '#00115': const [
    ChatMessage(
      text: 'The app crashes every time I try to open the transaction history tab. I have reinstalled twice and the problem persists.',
      timeAgo: '4 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'We are aware of this issue on certain devices. Could you share your device model and OS version so we can prioritize?',
      timeAgo: '4 days ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'Samsung Galaxy A55, Android 14.',
      timeAgo: '3 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Thank you. A fix has been included in our next release scheduled for this week. We will notify you once the update is available.',
      timeAgo: '2 days ago',
      isSender: false,
    ),
  ],
  '#00109': const [
    ChatMessage(
      text: 'I entered the wrong meter number during a token purchase. The token was sent to the wrong meter. Please help me reverse or redirect the purchase.',
      timeAgo: '5 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Please provide the correct meter number and the transaction reference so we can attempt a redirect.',
      timeAgo: '5 days ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'Correct meter: 04198237650. Reference: TXN-2026051500221.',
      timeAgo: '5 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'We have successfully redirected the token to the correct meter. Please enter the token on your meter to credit the units.',
      timeAgo: '4 days ago',
      isSender: false,
    ),
    ChatMessage(
      text: 'It worked! Units are now on my meter. Thank you so much.',
      timeAgo: '4 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Issue has been resolved. I will be closing this ticket now.',
      timeAgo: '4 days ago',
      isSender: false,
    ),
  ],
  '#00102': const [
    ChatMessage(
      text: 'My wallet balance is not updating after a bank transfer. The money left my bank account over 3 hours ago but the wallet still shows the old balance.',
      timeAgo: '6 days ago',
      isSender: true,
    ),
    ChatMessage(
      text: 'Please share your bank name, transfer amount, and the time of the transfer so we can trace the transaction.',
      timeAgo: '6 days ago',
      isSender: false,
    ),
  ],
};