from celery.schedules import crontab

beat_schedule = {
    "fetch-new-stories-every-10-mins": {
        "task": "app.task_manager.tasks.fetch_and_store_new_stories",
        "schedule": crontab(minute="*/10"),
    }
}
