use serde::Deserialize;
use yew::Properties;

#[derive(Clone, Debug, Deserialize, PartialEq, Properties)]
pub struct League {
    pub end_date: Option<String>,
    pub end_week: Option<String>,
    pub logo_url: Option<String>,
    pub draft_status: Option<String>,
    pub start_week: Option<String>,
    pub allow_add_to_dl_extra_pos: Option<i32>,
    pub is_cash_league: Option<String>,
    pub season: Option<String>,
    pub weekly_deadline: Option<String>,
    pub league_update_timestamp: Option<String>,
    pub league_key: Option<String>,
    pub start_date: Option<String>,
    pub scoring_type: Option<String>,
    pub edit_key: Option<String>,
    pub is_pro_league: Option<String>,
    pub felo_tier: Option<String>,
    pub url: Option<String>,
    pub is_finished: Option<i32>,
    pub is_plus_league: Option<String>,
    pub renewed: Option<String>,
    pub league_type: Option<String>,
    pub current_week: Option<i32>,
    pub short_invitation_url: Option<String>,
    pub name: Option<String>,
    pub num_teams: Option<i32>,
    pub renew: Option<String>,
    pub league_id: Option<String>,
    pub iris_group_chat_id: Option<String>,
    pub game_code: Option<String>,
}

#[derive(Clone, Debug, Deserialize)]
pub struct FantasyContent {
    pub xml_lang: Option<String>,
    pub copyright: String,
    pub yahoo_uri: Option<String>,
    pub league: Vec<League>,
    pub refresh_rate: String,
    pub time: String,
}

#[derive(Clone, Debug, Deserialize)]
pub struct StandingsResponse {
    pub fantasy_content: FantasyContent,
}

#[derive(Debug, Deserialize)]
struct StandingsEntry {
    teams: Team,
}

#[derive(Debug, Deserialize)]
struct Team {}

#[derive(Debug, Deserialize)]
enum LeagueVariant {
    #[serde(rename = "standings")]
    Standings(Vec<StandingsEntry>),
    #[serde(rename = "")]
    Other(League),
}