class TransactionDetails {
  final PersonalDetails personalDetails;
  final PaymentDetails paymentDetails;

  TransactionDetails({
    required this.personalDetails,
    required this.paymentDetails,
  });
}

class PersonalDetails {
  final String fullName;
  final String age;
  final String gender;
  final String contactNumber;
  final String emailAddress;
  final String emergencyPerson;
  final String emergencyNumber;
  final String emergencyRelation;

  PersonalDetails({
    required this.fullName,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.emailAddress,
    required this.emergencyPerson,
    required this.emergencyNumber,
    required this.emergencyRelation,
  });
}

class PaymentDetails {
  final String status;
  final String date;
  final String method;
  final String holderName;
  final String transactionId;
  final String serviceFee;
  final String distanceFee;
  final String total;

  PaymentDetails({
    required this.status,
    required this.date,
    required this.method,
    required this.holderName,
    required this.transactionId,
    required this.serviceFee,
    required this.distanceFee,
    required this.total,
  });
}
