import os

def main():
    app_name = os.getenv("APP_NAME", "{{PROJECT_NAME}}")
    print(f"Starting {app_name} microservice...")

if __name__ == "__main__":
    main()
