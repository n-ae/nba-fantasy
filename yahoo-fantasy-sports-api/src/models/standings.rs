use serde::Deserialize;

#[derive(Clone, Debug, Deserialize)]
struct OutcomeTotals {
    wins: usize,
    losses: usize,
    ties: usize,
    percentage: String, // TODO: consider decimal in the future?
}

#[derive(Clone, Debug, Deserialize)]
struct TeamStandings {
    rank: u8,
    playoff_seed: Option<u8>,
    outcome_totals: OutcomeTotals,
    games_back: Option<String>, // TODO: consider decimal in the future?
}

#[derive(Clone, Debug, Deserialize)]
struct TeamPoints {
    coverage_type: String,
    season: u16,
    total: Option<()>, // TODO: is this the proper way on valueless self closing tag?
}

#[derive(Clone, Debug, Deserialize)]
struct Stat {
    stat_id: u32,
    value: String,
}

#[derive(Clone, Debug, Deserialize)]
struct Stats {
    stat: Vec<Stat>,
}

#[derive(Clone, Debug, Deserialize)]
struct TeamStats {
    coverage_type: String,
    season: u16,
    stats: Stats,
}

#[derive(Clone, Debug, Deserialize)]
struct Manager {
    manager_id: u8,
    nickname: String,
    guid: String,
    is_current_login: Option<bool>,
    image_url: Option<String>,
    felo_score: Option<u16>,
    felo_tier: Option<String>,
}

#[derive(Clone, Debug, Deserialize)]
struct Managers {
    manager: Manager,
}

#[derive(Clone, Debug, Deserialize)]
struct RosterAdds {
    coverage_type: String,
    coverage_value: u8,
    value: usize,
}

#[derive(Clone, Debug, Deserialize)]
struct TeamLogo {
    size: String,
    url: String,
}

#[derive(Clone, Debug, Deserialize)]
struct TeamLogos {
    team_logo: TeamLogo,
}

#[derive(Clone, Debug, Deserialize)]
struct Team {
    team_key: String,
    team_id: u8,
    name: String,
    is_owned_by_current_login: Option<bool>,
    url: String,
    team_logos: TeamLogos,
    waiver_priority: Option<u8>,
    number_of_moves: Option<usize>,
    number_of_trades: Option<usize>,
    roster_adds: Option<RosterAdds>,
    clinched_playoffs: Option<bool>,
    league_scoring_type: Option<String>,
    has_draft_grade: Option<bool>,
    managers: Managers,
    team_stats: Option<TeamStats>,
    team_points: TeamPoints,
    team_standings: TeamStandings,
}

#[derive(Clone, Debug, Deserialize)]
struct Teams {
    // TODO
    #[serde(rename = "@count")]
    count: u8,
    team: Vec<Team>,
}

#[derive(Clone, Debug, Deserialize)]
pub struct Standings {
    teams: Teams,
    // TODO
    // #[serde(rename = "@count")]
    // count: u8,
}

#[derive(Clone, Debug, Deserialize)]
pub struct League {
    league_key: String,
    league_id: usize,
    pub name: String,
    url: String,
    logo_url: Option<String>,
    draft_status: String,
    num_teams: u8,
    edit_key: String,            // TODO: Date
    weekly_deadline: Option<()>, // TODO: is this the proper way on valueless self closing tag?
    league_update_timestamp: u32,
    scoring_type: String,
    // UNDOCUMENTED
    league_type: Option<String>,
    // UNDOCUMENTED
    renew: Option<String>,
    // UNDOCUMENTED
    renewed: Option<()>, // TODO: is this the proper way on valueless self closing tag?
    // UNDOCUMENTED
    felo_tier: Option<String>,
    // UNDOCUMENTED
    iris_group_chat_id: Option<()>, // TODO: is this the proper way on valueless self closing tag?
    // UNDOCUMENTED
    short_invitation_url: Option<String>,
    // UNDOCUMENTED
    allow_add_to_dl_extra_pos: Option<bool>,

    // don't care if documented or not
    is_pro_league: Option<bool>,
    is_cash_league: Option<bool>,
    current_week: u8,
    start_week: u8,
    start_date: Option<String>, // TODO: Date
    end_week: u8,
    end_date: Option<String>, // TODO: Date
    is_finished: bool,
    is_plus_league: Option<bool>,
    game_code: Option<String>,
    season: Option<u16>,
    pub standings: Standings,
}

#[derive(Clone, Debug, Deserialize)]
pub struct FantasyContent {
    pub league: League,
}
