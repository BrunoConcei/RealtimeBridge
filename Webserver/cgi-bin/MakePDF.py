# generate PDF
import logging
logging.getLogger('xhtml2pdf').addHandler(logging.NullHandler())

def pdf(time,msg_condition,DI):
    import jinja2
    from xhtml2pdf import pisa
    Environment = jinja2.Environment
    FileSystemLoader=jinja2.FileSystemLoader
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template("templates/report.html")
    template_vars = {"title" : "Real-time Bridge Structural Health Monitoring",
                     "bridgename" : "Powder Mill Bridge",
                     "date": time,
                     "bnum": "1234567",
                     "bloc": "Barre, MA",
                     "bowner": "Town of Barre",
                     "yearbuilt": "2009",
                     "insepctiondate": "2013",
                     "btype": "Steel Girder Composite",
                     "bcondition": msg_condition,
                     "bDI": DI
    }

    html_out = template.render(template_vars)

    resultFile = open('C:/Users/zzhao01/Documents/Webserver/website/Report.pdf', "w+b")
    pisa.CreatePDF(html_out.encode(), resultFile)
    resultFile.close()

if __name__ == '__main__':
    pdf(time,msg_condition,DI)
