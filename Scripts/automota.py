import schedule
import time
import subprocess

def run_r_script():
    subprocess.call([r"C:\Program Files\R\R-4.2.3\bin\R.exe", "CMD", "BATCH", r"C:\Users\jvelazhe\Desktop\R\cadahoraprev.R"])

schedule.every().hour.at(":32").do(run_r_script)

while True:
    schedule.run_pending()
    time.sleep(1)
