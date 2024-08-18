//jshint esversion:6
//CopyRight : Team Cultivators
const express = require("express");
const bodyParser = require("body-parser");
const https = require("https");
const fs = require("fs");
const { PythonShell } = require("python-shell");
const app = express();

app.use(bodyParser.json());
app.use(express.static("public"));

app.post("/predict", function (req, res) {
  const districtName = req.body.district;
  console.log(districtName);

  // Fetch weather data from OpenWeatherMap API
  const apikey = "05c210ab686ab28af7dcacdf1f407eb4";
  const unit = "metric";
  const url =
    "https://api.openweathermap.org/data/2.5/weather?q=" +
    districtName +
    "&appid=" +
    apikey +
    "&units=" +
    unit;
  https.get(url, function (response) {
    if (response.statusCode === 200) {
      response.on("data", function (data) {
        const weatherData = JSON.parse(data);
        const temp = weatherData.main.temp;
        const humid = weatherData.main.humidity;
        const rain = weatherData.rain ? weatherData.rain["3h"] : 0; // Check if rain data is available

        // Run Python script for crop prediction
        const options = {
          args: [temp, humid, rain],
        };
        PythonShell.run("crop_model.py", options, function (err, results) {
          if (err) {
            console.log(err);
            res.status(500).json({ error: "Error in running Python script" });
          } else {
            console.log(results);
            res.json({ crops: results });
          }
        });
      });
    } else {
      res.status(404).send("Data not found");
    }
  });
});

app.listen(process.env.PORT || 3000, function () {
  console.log("Server started on port 3000");
});
