#!/usr/bin/env python
import csv, os
from tabulate import tabulate
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib
import mimetypes
from email import encoders
from email.message import Message
from datetime import datetime, timedelta

yesterday = datetime.now() - timedelta(1)
bygone = datetime.strftime(yesterday, '%Y-%m-%d')
print(bygone)

def csv2htmlTableStr(CsvFileName):
    # this function is adapted from
    # https://stackoverflow.com/questions/36856011/convert-csv-to-a-html-table-format-and-store-in-a-html-file
    #
    # Open the CSV file for reading
    reader = csv.reader(open(CsvFileName))

    # initialize rownum variable
    rownum = 0

    # write <table> tag
    HtmlStr = ''
    HtmlStr += '<table border="1px solid black" text-align="center"  style="width:70%" class="fancy_grid">'
    # generate table contents

    for row in reader: # Read a single row from the CSV file

    # write header row. assumes first row in csv contains header

       if rownum == 0:
          HtmlStr += '<tr>' # write <tr> tag
          for column in row:
              HtmlStr += '<th bgcolor="orange">' + column +  '</th>'
          HtmlStr += '</tr>'

      #write all other rows
       else:
          HtmlStr += '<tr>'
          for column in row:
              HtmlStr += '<td align="center">' + column + '</td>'
          HtmlStr += '</tr>'

       #increment row count
       rownum += 1

     # write </table> tag
    HtmlStr += '</table>'

     # print results to shell
    #print "Created " + str(rownum) + " row table."
    return HtmlStr

from_email = "P2Sentinel@mail.cerner.com" # REPLACE THIS
#to_email = 'srikanthreddy.bathula@cerner.com' # REPLACE THIS
to_email  = 'srikanthreddy.bathula@cerner.com,DL_P2Sentinel_Dev@cerner.com,DL_Splunk_CoE@cerner.com'

#csv0 = "/Users/sb065394/Desktop/CernerWorks/python-2020/eventcount/e_count.csv"
csv1 = "/opt/scripts/e_count.csv"
csv2 = "/opt/scripts/e_count_202.csv"

csv1Str = csv2htmlTableStr(csv1)
csv2Str = csv2htmlTableStr(csv2)

text = """
EventCount from cernsnlcalis201.cerncd.com :

""" + csv1Str + """

EventCount from cernsnlcalis202.cerncd.com:

""" + csv2Str + """

"""

html = """
<html><body>
<p><b><font color='blue'>EventCount from cernsnlcalis201.cerncd.com :</font></b></p>
""" + csv1Str + """</p>
<p><b><font color='blue'>EventCount from cernsnlcalis202.cerncd.com:</font></b></p>
""" + csv2Str + """</p>
</body></html>
"""

message = MIMEMultipart(
    "alternative", None, [MIMEText(text), MIMEText(html,'html')])

debug = False
if debug:
    print(message.as_string())
else:
    message['Subject'] = "EventCount from P2ProdCA(aws) for "+ bygone
    message['From'] = from_email
    message['To'] = to_email
    server = smtplib.SMTP('mail.cernerasp.com')
    server.ehlo()
    server.starttls()
    #server.login(from_email, password)
    server.sendmail(from_email, to_email, message.as_string())
    server.quit()
