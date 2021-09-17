
Example: 

```bash
./docker-container-monitor.sh -h '5 seconds' -r 1s -f '{{.Container}},{{.CPUPerc}}' -c container_name -o container_name.log
./docker-container-monitor.sh -h '1 minuteS' -r 1m -f '{{.Container}},{{.CPUPerc}}' -c container_name -o container_name.log
./docker-container-monitor.sh -h '5 minuteS' -r 5s -f '{{.Container}},{{.CPUPerc}}' -c container_name -o container_name.log
```
