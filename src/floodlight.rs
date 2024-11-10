pub struct App {
    pub tide: tide::Server<()>,
}

impl App {
    pub fn new() -> Self {
        let mut tide = tide::new();
        tide.at("/_fl/hello").get(hello);
        Self {
            tide,
        }
    }
}

async fn hello(mut _req: tide::Request<()>) -> tide::Result {
    Ok("hewwo :3 *paws at you*".into())
}
