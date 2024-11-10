use tide::Request;

#[tokio::main]
async fn main() -> tide::Result<()> {
    let mut app = tide::new();
    app.at("/").get(demo);
    app.listen("127.0.0.1:20114").await?;
    Ok(())
}

async fn demo(mut _req: Request<()>) -> tide::Result {
    Ok("Hello!".into())
}
