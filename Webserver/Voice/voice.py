# Download the Python helper library from twilio.com/docs/python/install
from twilio.rest import TwilioRestClient
 
# Your Account Sid and Auth Token from twilio.com/user/account
ACCOUNT_SID = "ACbb9db4553761639ba50b64b4dc7935a9" 
AUTH_TOKEN = "070e0e67cd1ba5f909f306db5ba0ecfb" 
client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)
 
token = client.tokens.create()
print token.username