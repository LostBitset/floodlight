#[tokio::main]
async fn main() -> tide::Result<()> {
    let app = floodlight::App::new();
    app.tide.listen("127.0.0.1:20114").await?;
    Ok(())
}
