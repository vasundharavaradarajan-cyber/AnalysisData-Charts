# selector

set.seed(2026)
donors <- c("H20.33.016", "H20.33.011", "H20.33.018", "H20.33.026",
            "H20.33.028", "H20.33.029", "H21.33.009", "H20.33.037",
            "H20.33.038", "H20.33.041", "H20.33.045", "H21.33.007",
            "H21.33.002", "H21.33.008", "H20.33.031", "H21.33.010",
            "H21.33.012", "H21.33.013", "H21.33.017", "H21.33.034",
            "H21.33.039", "H21.33.042", "H21.33.044", "H21.33.045")

selected_donors <- sample(donors, size = 4, replace = FALSE)
print(selected_donors)

set.seed(2026)
donors <- c("H20.33.004", "H20.33.040", "H21.33.020", "H20.33.020",
            "H20.33.033", "H20.33.015", "H20.33.046", "H21.33.005",
            "H20.33.017", "H21.33.021", "H21.33.027", "H21.33.031",
            "H21.33.029", "H21.33.046")

selected_donors <- sample(donors, size = 4, replace = FALSE)
print(selected_donors)

set.seed(2026)
donors <- c("H21.33.003", "H20.33.044", "H20.33.001", "H21.33.015", 
            "H21.33.004", "H21.33.023", "H21.33.019", "H21.33.028")

selected_donors <- sample(donors, size = 4, replace = FALSE)
print(selected_donors)

set.seed(2026)
donors <- c("H19.33.004", "H20.33.002", "H21.33.032", "H20.33.035", 
            "H21.33.011", "H20.33.012", "H21.33.037", "H21.33.041", 
            "H21.33.038")
selected_donors <- sample(donors, size = 4, replace = FALSE)
print(selected_donors)
