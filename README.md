# Monity - Digital Banking App

Monity is a simple and intuitive digital banking app designed specifically for the Nigerian market. It provides users with seamless banking experiences, including account management, money transfers, and transaction tracking. This README provides an overview of the app's features, installation instructions, and space for screenshots showcasing the user interface.

# Features
## User Authentication
Sign Up: New users can create an account using their email and password.
Login: Existing users can log in with their credentials.
Profile Completion: After logging in, users complete their profile by providing additional details.
## Account Management
Profile Setup: Users can update their profile information, change passwords, and manage security settings.
Passcode Setup: Users set a 4-digit passcode for secure banking transactions.
## Transactions
View Transactions: Users can view all their transactions grouped by date.
Send Money: Users can send money to other Monity users.
Request Money: Users can request money from other Monity users.
Transaction Notifications: Users receive notifications about their transactions.
## Balance Management
View Balance: Users can view their account balance.
Top-Up Balance: Users can top-up their account balance.
## Security
App Passcode: Users can set and change their app passcode for additional security.

## sample login for testing the app:
email: infotezma@gmail.com
password Babcock135790
passcode: 1357

email: divzeh001@gmail.com
password Babcock135790
passcode: 1357

## APK file link: [https://drive.google.com/file/d/1Y2o61AR76wlerE2OC0zAQbN7iu0s0zxa/view?usp=gmail](https://drive.google.com/file/d/1uxlQdHBki7G43_FFsT9h3pdfTQa03q9f/view)

![Screenshot 2024-07-16 123601](https://github.com/user-attachments/assets/2a2843a4-7de5-468f-8d3d-c74548e1aa65)

![Screenshot 2024-07-16 123317](https://github.com/user-attachments/assets/7115432f-b3eb-48ee-9952-1b9f976d25af)

![Screenshot 2024-07-16 123519](https://github.com/user-attachments/assets/0f78d8ae-29da-46d5-893b-2f8cb003d96c)

![Screenshot 2024-07-16 123539](https://github.com/user-attachments/assets/d8eb826b-5659-4a81-8399-56d867beeba7)


## Getting Started

## Installation
- Clone the Repository:

bash
Copy code
git clone https://github.com/yourusername/monity.git
cd monity
Install Dependencies:

bash
Copy code
flutter pub get
Set Up Supabase:

Create a Supabase project.
Set up authentication and database tables as required by the app.
Update the lib/constants.dart file with your Supabase URL and API key.
Run the App:

bash
Copy code
flutter run 

# Supabase - creation of tables and functions 

Sure, here’s a detailed list of the tables and functions created for Monity, along with brief descriptions of their purpose:

### Supabase Tables and Functions

#### Tables

1. **auth.users**
   - **Description**: This is the default table for storing user authentication information, including email and password.

2. **profile_info**
   - **Description**: Stores additional user information such as first name, last name, profile picture, and other personal details.
   - **Columns**:
     - `id`: Foreign key linking to `auth.users`.
     - `first_name`: User's first name.
     - `last_name`: User's last name.
     - `profile_picture`: URL to the user's profile picture.
     - `account_number`: 11-digit unique account number.
     - `balance`: User's account balance.

3. **user_passcodes**
   - **Description**: Stores the 4-digit passcodes for users to secure their banking transactions.
   - **Columns**:
     - `user_id`: Foreign key linking to `auth.users`.
     - `passcode`: Encrypted 4-digit passcode.

4. **transaction_logs_with_names**
   - **Description**: Stores transaction logs with detailed information about each transaction.
   - **Columns**:
     - `transaction_id`: Unique identifier for each transaction.
     - `timestamp`: The date and time of the transaction.
     - `sender_profile_id`: Foreign key linking to the sender's profile.
     - `recipient_profile_id`: Foreign key linking to the recipient's profile.
     - `amount`: The transaction amount.
     - `transaction_type`: Type of transaction (debit or credit).
     - `transaction_reference`: 20-character unique reference for the transaction.
     - `transaction_status`: Status of the transaction (completed, pending, etc.).
     - `sender_name`: Name of the sender.
     - `recipient_name`: Name of the recipient.

5. **transaction_receipt**
   - **Description**: Stores transaction receipts containing the reference and status of each transaction.
   - **Columns**:
     - `transaction_reference`: 20-character unique reference.
     - `transaction_status`: Status of the transaction (completed, pending, etc.).

#### Functions and Triggers

1. **generate_account_number**
   - **Description**: Generates a random 11-digit account number for new users.
   - **Implementation**:
     ```sql
     CREATE OR REPLACE FUNCTION generate_account_number()
     RETURNS TRIGGER AS $$
     BEGIN
       NEW.account_number := floor(random() * 100000000000)::integer;
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;
     ```

2. **trigger_generate_account_number**
   - **Description**: Trigger to automatically call `generate_account_number` when a new profile is created.
   - **Implementation**:
     ```sql
     CREATE TRIGGER trigger_generate_account_number
     BEFORE INSERT ON profile_info
     FOR EACH ROW
     EXECUTE FUNCTION generate_account_number();
     ```

3. **send_transaction_notification**
   - **Description**: Sends a push notification to users when a transaction occurs.
   - **Implementation**:
     ```sql
     CREATE OR REPLACE FUNCTION send_transaction_notification()
     RETURNS TRIGGER AS $$
     BEGIN
       PERFORM pg_notify('transaction_channel', json_build_object(
         'user_id', NEW.recipient_profile_id,
         'message', 'You have received a transaction of ' || NEW.amount
       )::text);
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql;
     ```

4. **trigger_send_transaction_notification**
   - **Description**: Trigger to automatically call `send_transaction_notification` when a new transaction log is inserted.
   - **Implementation**:
     ```sql
     CREATE TRIGGER trigger_send_transaction_notification
     AFTER INSERT ON transaction_logs_with_names
     FOR EACH ROW
     EXECUTE FUNCTION send_transaction_notification();
     ```

#### Example Supabase Logic (Dart)

1. **Fetching User Profile Information**
   - **Description**: Retrieves the profile information for the current user.
   - **Implementation**:
     ```dart
     Future<Map<String, dynamic>?> getUserProfileInfo() async {
       final response = await supabase
           .from('profile_info')
           .select('*')
           .eq('id', Supabase.instance.client.auth.currentUser?.id)
           .single();
       return response.data;
     }
     ```

2. **Fetching Transactions**
   - **Description**: Retrieves transaction logs related to the current user.
   - **Implementation**:
     ```dart
     Future<List<Map<String, dynamic>>> fetchTransactions(String profileId) async {
       final response = await supabase
           .from('transaction_logs_with_names')
           .select('*')
           .or('sender_profile_id.eq.$profileId,recipient_profile_id.eq.$profileId')
           .order('timestamp', ascending: false);
       return response;
     }
     ```

3. **Grouping Transactions by Date**
   - **Description**: Groups transactions by date for display in the app.
   - **Implementation**:
     ```dart
     List<Map<String, dynamic>> groupTransactionsByDate(
         List<Map<String, dynamic>> transactions, String userId) {
       final groupedTransactions = <String, List<Map<String, dynamic>>>{};

       for (var transaction in transactions) {
         if (transaction['sender_profile_id'] == userId) {
           final timestamp = DateTime.parse(transaction['timestamp']);
           final dateKey = _formatDateKey(timestamp);

           if (groupedTransactions.containsKey(dateKey)) {
             groupedTransactions[dateKey]!.add(transaction);
           } else {
             groupedTransactions[dateKey] = [transaction];
           }
         }
       }

       return groupedTransactions.entries.map((entry) {
         return {
           'date': entry.key,
           'transactions': entry.value,
         };
       }).toList();
     }

     String _formatDateKey(DateTime date) {
       final now = DateTime.now();
       final today = DateTime(now.year, now.month, now.day);
       final transactionDate = DateTime(date.year, date.month, date.day);

       if (transactionDate == today) {
         return 'Today';
       } else {
         return DateFormat('MMMM dd, yyyy').format(date);
       }
     }
     ```

---

# Contribution: I welcome any suggestions. 
thank you, please leave a star!

