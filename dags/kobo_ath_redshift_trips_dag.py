import airflow
# the dag object is to instantiate dag
from airflow import DAG
# Operators : since we would be only scheduling a script we would need only a bash operator 
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import pandas as pd

# Pass a set of default arguments 
# Set the default arguments: Owner name, trigger rule and no of retries

default_args = {
    'owner' : 'Sabiha',

# email 
    'email': ['sabiha.farhat@rubikonlabs.com'],
    'email_on_failure' : True,
    'email_on_retry' : True,
    'trigger_rule': 'all_success',
    'retries': 1

}

# Instantiate a dag
# DAG contains dag_id, default args, description of the tag, start_date, schedule_interval, max_active runs and catchup as false to eliminate any back fills) 
# Startdate would indicate when the dag would begin running
# run task in every 6 hrs interval

dag = DAG(
    'Athena_redshift_schedule',
    default_args=default_args,
    description='Schedule trips athena_redshift.py script',
    start_date=datetime(2020, 9, 22, 0, 0),
    schedule_interval='0 */6 * * *',
    max_active_runs=1,
    catchup=False
          )

# bash operator to run the scripts in the shell
# bash command path indicates where the pipeline code and its dependencies are located
t1 = BashOperator(
    task_id = 'run_athena_redshift',
    bash_command = 'python3 /home/ubuntu/datapipeline_scripts/trips/athena_redshift.py',
    dag=dag
)

# only one task t1 to be executed
t1


