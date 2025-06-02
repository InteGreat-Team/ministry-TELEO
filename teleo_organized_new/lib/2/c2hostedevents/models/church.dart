// This file contains the shared data model for churches and their members

// Dummy data for churches and their members
final List<Map<String, dynamic>> dummyChurches = [
  {
    'name': 'Sunny Bay View Church',
    'registrants': 25,
    'members': [
      {
        'name': 'Pastor Michael Smith', 
        'status': 'Checked-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Sunny Bay View Church',
        'date': 'March 15, 2025',
        'personalInfo': {
          'email': 'pastor.michael@sunnybaychurch.org',
          'phone': '+1 (555) 123-4567',
          'address': '123 Sunny Lane, Bay City, CA 94123',
          'age': 45,
          'gender': 'Male',
          'occupation': 'Pastor'
        },
        'registrationForm': {
          'submissionDate': 'February 1, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Mary Smith - +1 (555) 123-4568',
          'specialRequests': 'Reserved seating in front row'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Credit Card',
          'transactionId': 'TXN-12345-ABCDE',
          'paymentDate': 'February 1, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Sarah Johnson', 
        'status': 'Checked-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Sunny Bay View Church',
        'date': 'March 15, 2025',
        'personalInfo': {
          'email': 'sarah.j@example.com',
          'phone': '+1 (555) 234-5678',
          'address': '456 Church St, Bay City, CA 94123',
          'age': 32,
          'gender': 'Female',
          'occupation': 'Teacher'
        },
        'registrationForm': {
          'submissionDate': 'February 3, 2025',
          'dietaryRestrictions': 'Vegetarian',
          'emergencyContact': 'John Johnson - +1 (555) 234-5679',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Cash',
          'transactionId': 'TXN-23456-BCDEF',
          'paymentDate': 'February 3, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'David Williams', 
        'status': 'Yet to Check-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Sunny Bay View Church',
        'date': 'March 15, 2025',
        'personalInfo': {
          'email': 'david.w@example.com',
          'phone': '+1 (555) 345-6789',
          'address': '789 Worship Ave, Bay City, CA 94123',
          'age': 28,
          'gender': 'Male',
          'occupation': 'Software Engineer'
        },
        'registrationForm': {
          'submissionDate': 'February 5, 2025',
          'dietaryRestrictions': 'Gluten-free',
          'emergencyContact': 'Lisa Williams - +1 (555) 345-6780',
          'specialRequests': 'Needs accessible seating'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Mobile Payment',
          'transactionId': 'TXN-34567-CDEFG',
          'paymentDate': 'February 5, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Emily Davis', 
        'status': 'Checked-In', 
        'type': 'WALK-IN',
        'church': 'Sunny Bay View Church',
        'date': 'March 15, 2025',
        'personalInfo': {
          'email': 'emily.d@example.com',
          'phone': '+1 (555) 456-7890',
          'address': '101 Faith Road, Bay City, CA 94123',
          'age': 24,
          'gender': 'Female',
          'occupation': 'Nurse'
        },
        'registrationForm': {
          'submissionDate': 'March 15, 2025 (Walk-in)',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'James Davis - +1 (555) 456-7891',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Cash',
          'transactionId': 'WALK-IN-45678',
          'paymentDate': 'March 15, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Robert Brown', 
        'status': 'Yet to Check-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Sunny Bay View Church',
        'date': 'March 15, 2025',
        'personalInfo': {
          'email': 'robert.b@example.com',
          'phone': '+1 (555) 567-8901',
          'address': '202 Gospel Street, Bay City, CA 94123',
          'age': 35,
          'gender': 'Male',
          'occupation': 'Accountant'
        },
        'registrationForm': {
          'submissionDate': 'February 10, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Anna Brown - +1 (555) 567-8902',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Credit Card',
          'transactionId': 'TXN-56789-EFGHI',
          'paymentDate': 'February 10, 2025',
          'status': 'Paid'
        }
      },
    ]
  },
  {
    'name': 'Grace Fellowship',
    'registrants': 7,
    'members': [
      {
        'name': 'Alvaro Flores', 
        'status': 'Yet to Check-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'alvaro.f@gracefellowship.org',
          'phone': '+1 (555) 678-9012',
          'address': '303 Grace Avenue, Graceville, CA 94456',
          'age': 42,
          'gender': 'Male',
          'occupation': 'Business Owner'
        },
        'registrationForm': {
          'submissionDate': 'February 12, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Maria Flores - +1 (555) 678-9013',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Bank Transfer',
          'transactionId': 'TXN-67890-FGHIJ',
          'paymentDate': 'February 12, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Brent Damian', 
        'status': 'Checked-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'brent.d@example.com',
          'phone': '+1 (555) 789-0123',
          'address': '404 Fellowship Lane, Graceville, CA 94456',
          'age': 29,
          'gender': 'Male',
          'occupation': 'Marketing Manager'
        },
        'registrationForm': {
          'submissionDate': 'February 15, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Tina Damian - +1 (555) 789-0124',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Credit Card',
          'transactionId': 'TXN-78901-GHIJK',
          'paymentDate': 'February 15, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Cristie Poloso', 
        'status': 'Checked-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'cristie.p@example.com',
          'phone': '+1 (555) 890-1234',
          'address': '505 Blessing Road, Graceville, CA 94456',
          'age': 31,
          'gender': 'Female',
          'occupation': 'Graphic Designer'
        },
        'registrationForm': {
          'submissionDate': 'February 18, 2025',
          'dietaryRestrictions': 'Lactose Intolerant',
          'emergencyContact': 'Marco Poloso - +1 (555) 890-1235',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Mobile Payment',
          'transactionId': 'TXN-89012-HIJKL',
          'paymentDate': 'February 18, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Dompoa Dominga', 
        'status': 'Checked-In', 
        'type': 'WALK-IN',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'dompoa.d@example.com',
          'phone': '+1 (555) 901-2345',
          'address': '606 Prayer Street, Graceville, CA 94456',
          'age': 27,
          'gender': 'Female',
          'occupation': 'Student'
        },
        'registrationForm': {
          'submissionDate': 'March 20, 2025 (Walk-in)',
          'dietaryRestrictions': 'Vegan',
          'emergencyContact': 'Domingo Dominga - +1 (555) 901-2346',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Cash',
          'transactionId': 'WALK-IN-90123',
          'paymentDate': 'March 20, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Elemar De Guzman', 
        'status': 'Checked-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'elemar.g@example.com',
          'phone': '+1 (555) 012-3456',
          'address': '707 Worship Circle, Graceville, CA 94456',
          'age': 33,
          'gender': 'Male',
          'occupation': 'IT Specialist'
        },
        'registrationForm': {
          'submissionDate': 'February 20, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Elena De Guzman - +1 (555) 012-3457',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Credit Card',
          'transactionId': 'TXN-01234-JKLMN',
          'paymentDate': 'February 20, 2025',
          'status': 'Paid'
        }
      },
      {
        'name': 'Fr. Aaron Ladores', 
        'status': 'Yet to Check-In', 
        'type': 'INVITED PASTOR',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'fr.aaron@diocese.org',
          'phone': '+1 (555) 123-4567',
          'address': '808 Holy Street, Graceville, CA 94456',
          'age': 48,
          'gender': 'Male',
          'occupation': 'Priest'
        },
        'registrationForm': {
          'submissionDate': 'February 22, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Diocese Office - +1 (555) 123-4560',
          'specialRequests': 'Reserved seating'
        },
        'paymentDetails': {
          'amount': 'Complimentary',
          'paymentMethod': 'N/A',
          'transactionId': 'COMP-PASTOR-12345',
          'paymentDate': 'N/A',
          'status': 'Complimentary'
        }
      },
      {
        'name': 'Isodoro Arawan Bahano', 
        'status': 'Yet to Check-In', 
        'type': 'LEADER',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'isodoro.b@gracefellowship.org',
          'phone': '+1 (555) 234-5678',
          'address': '909 Leadership Lane, Graceville, CA 94456',
          'age': 52,
          'gender': 'Male',
          'occupation': 'Church Elder'
        },
        'registrationForm': {
          'submissionDate': 'February 25, 2025',
          'dietaryRestrictions': 'Low sodium',
          'emergencyContact': 'Isabela Bahano - +1 (555) 234-5679',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'Complimentary',
          'paymentMethod': 'N/A',
          'transactionId': 'COMP-LEADER-23456',
          'paymentDate': 'N/A',
          'status': 'Complimentary'
        }
      },
      {
        'name': 'Alyssa Elona', 
        'status': 'Yet to Check-In', 
        'type': 'PRE-REGISTERED',
        'church': 'Grace Fellowship',
        'date': 'March 20, 2025',
        'personalInfo': {
          'email': 'alyssa.e@example.com',
          'phone': '+1 (555) 345-6789',
          'address': '1010 Faith Street, Graceville, CA 94456',
          'age': 26,
          'gender': 'Female',
          'occupation': 'Event Coordinator'
        },
        'registrationForm': {
          'submissionDate': 'February 28, 2025',
          'dietaryRestrictions': 'None',
          'emergencyContact': 'Elias Elona - +1 (555) 345-6780',
          'specialRequests': 'None'
        },
        'paymentDetails': {
          'amount': 'P200.00',
          'paymentMethod': 'Bank Transfer',
          'transactionId': 'TXN-34567-KLMNO',
          'paymentDate': 'February 28, 2025',
          'status': 'Paid'
        }
      },
    ]
  },
];
