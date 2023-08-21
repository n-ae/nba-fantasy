pub fn get_proxied_url(standings_url: &str) -> String {
    return [dotenv!("CORS_REVERSE_PROXY_ENDPOINT"), standings_url]
        .iter()
        .copied()
        .skip_while(|&x| x.is_empty())
        .collect::<Vec<&str>>()
        .join("/");
}
