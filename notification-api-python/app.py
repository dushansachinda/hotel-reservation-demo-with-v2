from flask import Flask, request, jsonify
from azure.communication.email import EmailClient
import os

app = Flask(__name__)

# Configuration values from environment or configuration file
connection_string = os.environ.get('AZURE_COMM_SERVICES_CONNECTION_STRING')
sender_address = os.environ.get('AZURE_COMM_SERVICES_SENDER_ADDRESS')

email_client = EmailClient.from_connection_string(connection_string)

@app.route('/notifications/send-email', methods=['POST'])
def send_email():


    email_request = request.get_json()
    recipient = email_request['recipient']
    subject = email_request['subject']
    body = email_request['body']

    message = {
        "senderAddress": sender_address,
        "recipients": {
            "to": [{"address": recipient}],
        },
        "content": {
            "subject": subject,
            "plainText": body,
            "html": "<html><body><p>" + body + "</p></body></html>",
        }
    }

    app.logger.debug("Received !!!!! request for /notifications/send-email")
    
    POLLER_WAIT_TIME = 5
    poller = email_client.begin_send(message)

    time_elapsed = 0
    while not poller.done():
        print("Email send poller status: " + poller.status())

        poller.wait(POLLER_WAIT_TIME)
        time_elapsed += POLLER_WAIT_TIME

        if time_elapsed > 18 * POLLER_WAIT_TIME:
            raise RuntimeError("Polling timed out.")

    if poller.result()["status"] == "Succeeded":
        return jsonify({"message": "Email sent successfully"}), 200
    else:
        return jsonify({"message": "Failed to send email"}), 500

if __name__ == '__main__':
    app.run(debug=False, port=8081)
