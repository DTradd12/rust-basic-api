use std::env;
use dotenv::dotenv;

use reqwest::Error;

#[derive(Debug, serde::Deserialize)]
pub(crate) struct NasaAPIResponse {
    pub(crate) url: String,
}
pub(crate) async fn nasa_repository() -> Result<NasaAPIResponse, Error> {
    dotenv().ok();
    let api_key = "sVjAbjf7q02NRHnHMdGUa8R6Gpvk6E49l0EwMfzu";

    let url = format!("https://api.nasa.gov/planetary/apod?api_key={}", api_key);

    let response_body: NasaAPIResponse = reqwest::get(url).await?.json().await?;

    Ok(response_body)
}