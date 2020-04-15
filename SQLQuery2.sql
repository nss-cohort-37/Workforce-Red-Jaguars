SELECT CONCAT(c.Make, ' ', c.Model) AS ComputerInfo, c.Id, e.FirstName FROM Computer c
LEFT JOIN Employee e ON e.ComputerId = c.Id
                                        WHERE c.DecomissionDate IS NULL AND e.ComputerId IS NULL
