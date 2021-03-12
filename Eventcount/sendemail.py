#!/usr/bin/python3

import pandas as pd
import csv
from tabulate import tabulate
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib

password = ''
server = 'mail.cernerasp.com'
from_email = 'P2Sentinel@mail.cerner.com'
to_email  = 'srikanthreddy.bathula@cerner.com,DL_P2Sentinel_Dev@cerner.com,DL_Splunk_CoE@cerner.com'
#to_email  = 'srikanthreddy.bathula@cerner.com'


text = """
Hello, 

Here is your data:

{table}

Regards,

Me"""

html = """
<html>
<head>
<style>
 table, th, td {{ border: 1px solid black; border-collapse: collapse; }}
  th, td {{ padding: 5px; }}
</style>
</head>
<body><p>Hello</p>
<p>P2Prod-Canada(AWS):Below is yesterdays event_count from SHC and event_count from Listener for listener-box cernsnlcalis201.cerncd.com</p>
{table}
<p>Regards,</p>
<p>cernsnlcalis201.cerncd.com</p>
</body></html>
"""

# with open('input.csv') as input_file:
#     reader = csv.reader(input_file)
#     data = list(reader)

df = pd.read_csv("e_count.csv")
col_list = list(df.columns.values)
data = df
# above line took every col inside csv as list
text = text.format(table=tabulate(data, headers=col_list, tablefmt="grid"))
html = html.format(table=tabulate(data, headers=col_list, tablefmt="html"))

message = MIMEMultipart(
    "alternative", None, [MIMEText(text), MIMEText(html,'html')])

message['Subject'] = "EventCount from P2ProdCA"
message['From'] = from_email
message['To'] = to_email
server = smtplib.SMTP(server)
server.ehlo()
server.starttls()
#server.login(from_email, password)
server.sendmail(from_email, to_email, message.as_string())
server.quit()
