x <- httr2::request(base_url = "https://resultados.tse.jus.br/oficial/ele2022/544/dados-simplificados/br/br-c0001-e000544-r.json") |>
  httr2::req_throttle(rate = 1) |>
  httr2::req_retry(max_tries = 10) |>
  httr2::req_perform() |>
  httr2::resp_body_json()

table <- tibble::tribble(
  ~Candidato, ~VotosTotais, ~Percentual,
  x$cand[[1]]$nm, x$cand[[1]]$vap, x$cand[[1]]$pvap,
  x$cand[[2]]$nm, x$cand[[2]]$vap, x$cand[[2]]$pvap,
  x$cand[[3]]$nm, x$cand[[3]]$vap, x$cand[[3]]$pvap,
  x$cand[[4]]$nm, x$cand[[4]]$vap, x$cand[[4]]$pvap,
  x$cand[[5]]$nm, x$cand[[5]]$vap, x$cand[[5]]$pvap,
  x$cand[[6]]$nm, x$cand[[6]]$vap, x$cand[[6]]$pvap,
  x$cand[[7]]$nm, x$cand[[7]]$vap, x$cand[[7]]$pvap,
  x$cand[[8]]$nm, x$cand[[8]]$vap, x$cand[[8]]$pvap,
  x$cand[[9]]$nm, x$cand[[9]]$vap, x$cand[[9]]$pvap,
  x$cand[[10]]$nm, x$cand[[10]]$vap, x$cand[[10]]$pvap,
  x$cand[[11]]$nm, x$cand[[11]]$vap, x$cand[[11]]$pvap,) |>
  dplyr::mutate(
    Candidato = gsub(pattern = "&apos;", replacement = "'", x = Candidato),
    VotosTotais = as.numeric(sub(",", ".", VotosTotais, fixed = TRUE)),
    Percentual = as.numeric(sub(",", ".", Percentual, fixed = TRUE))
  ) |>
  dplyr::arrange(-Percentual)

message(paste(x$dg, x$hg))
message(paste("Percentual apurado:", x$pst))
knitr::kable(table, "simple", format.args = list(big.mark = ".", decimal.mark = ","))
