terraform {
  cloud {
    organization = "balii"

    workspaces {
      name = "nba-fantasy"
    }
  }
}
