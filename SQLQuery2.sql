SELECT e.FirstName, e.LastName, d.Name FROM Employee e
                                        LEFT JOIN Department d ON d.Id = e.DepartmentId