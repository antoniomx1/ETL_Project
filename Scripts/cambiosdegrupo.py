import pandas as pd
import yagmail

def send_email_with_attachment(receiver_email, subject, body, attachment_path):
    """
    Envía un correo electrónico con un archivo adjunto.

    :param receiver_email: Dirección de correo electrónico del destinatario.
    :param subject: Asunto del correo electrónico.
    :param body: Cuerpo del correo electrónico.
    :param attachment_path: Ruta del archivo a adjuntar.
    """
    # credenciales de correo
    yag = yagmail.SMTP(user='direccion_academica@utel.mx', password='3ef8uttoz2QE', host='smtp.utel.mx', port=465)
    
    # Enviar el correo
    yag.send(
        to=receiver_email,
        subject=subject,
        contents=body,
        attachments=attachment_path,
    )

def main():
    # Ruta del archivo CSV
    csv_path = "C:/Users/jvelazhe/Desktop/logistica/Reporte_Cambios_Grupos.csv"
    
    # Configurar destinatario y contenido del correo
    receiver_email = "jvelazhe@utel.edu.mx"
    subject = "Reporte de Cambios en Grupos"
    body = """
    Hola,

    Adjunto encontrarás el reporte de cambios en los grupos.

    Saludos,
    Dirección Académica
    """
    
    # Enviar el correo con el archivo adjunto
    send_email_with_attachment(receiver_email, subject, body, csv_path)

if __name__ == "__main__":
    main()
