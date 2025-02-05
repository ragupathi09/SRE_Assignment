
import requests

ALLOWED_VALUES = ["Data", "Processing", "Web"]

def get_allowed_service_values():

# tags value am not set here if tags are match then get resposponce will work
      if (tags_value in ALLOWED_VALUS):
      
           url = "http://<private-endpoint>/allowed-services"
          
          try:
              response = requests.get(url)
              response.raise_for_status()  
              data = response.json()
              allowed_services = data.get("ALLOWED_VALUES", [])
              return allowed_services
          except requests.RequestException as e:
              print(f"Error during GET request: {e}")
              return None


allowed_values = get_allowed_service_values()
    if allowed_values:
        print("Allowed Service Tag Values:", allowed_values)
    else:
        print("Failed to retrieve allowed service values.")
