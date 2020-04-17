using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using BangazonWorkforce.Models;
using BangazonWorkforce.Models.ViewModel;

namespace BangazonWorkforce.Controllers
{
    public class EmployeesController : Controller
    {

        private readonly IConfiguration _config;

        public EmployeesController(IConfiguration config)
        {
            _config = config;
        }

        public SqlConnection Connection
        {
            get
            {
                return new SqlConnection(_config.GetConnectionString("DefaultConnection"));
            }
        }

        // GET: Employees
        public ActionResult Index()
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT e.Id, e.FirstName, e.LastName, e.DepartmentId, d.[Name] AS DepartmentName FROM Employee e
                                        LEFT JOIN Department d ON d.Id = e.DepartmentId";

                    var reader = cmd.ExecuteReader();
                    var employees = new List<Employee>();

                    while (reader.Read())
                    {
                        var employee = new Employee()
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            FirstName = reader.GetString(reader.GetOrdinal("FirstName")),
                            LastName = reader.GetString(reader.GetOrdinal("LastName")),
                            DepartmentId = reader.GetInt32(reader.GetOrdinal("DepartmentId")),
                            Department = new Department
                            {
                                Id = reader.GetInt32(reader.GetOrdinal("DepartmentId")),
                                Name = reader.GetString(reader.GetOrdinal("DepartmentName"))
                            }

                        };
                        employees.Add(employee);
                    }
                    reader.Close();
                    return View(employees);
                }
            }
        }

        // GET: Employees/Details/5
        public ActionResult Details(int id)
        {
            var employee = GetEmployeeById(id);
            return View(employee);
        }

        // GET: Employees/Create
        public ActionResult Create()
        {
            var departmentOptions = GetDepartmentOptions();
            var computerOptions = GetComputerOptions(null);
            var viewModel = new EmployeeViewModel()
            {
                DepartmentOptions = departmentOptions,
                ComputerOptions = computerOptions
            };
            return View(viewModel);
        }

        // POST: Employees/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(EmployeeViewModel employee)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @"INSERT INTO Employee (FirstName, LastName, DepartmentId, Email, IsSupervisor, ComputerId)
                                            OUTPUT INSERTED.Id
                                            VALUES (@firstName, @lastName, @departmentId, @email, @isSupervisor, @computerId)";

                        cmd.Parameters.Add(new SqlParameter("@firstName", employee.FirstName));
                        cmd.Parameters.Add(new SqlParameter("@lastName", employee.LastName));
                        cmd.Parameters.Add(new SqlParameter("@departmentId", employee.DepartmentId));
                        cmd.Parameters.Add(new SqlParameter("@email", employee.Email));
                        cmd.Parameters.Add(new SqlParameter("@isSupervisor", employee.IsSupervisor));
                        cmd.Parameters.Add(new SqlParameter("@computerId", employee.ComputerId));


                        var id = (int)cmd.ExecuteScalar();
                        employee.Id = id;

                        return RedirectToAction(nameof(Index));
                    }
                }


            }
            catch (Exception ex)
            {
                return View(employee);
            }
        }

        public ActionResult AssignTraining(int id)
        {
            var trainingOptions = GetAvaialbleTrainingOptions(id);
            var viewModel = new EmployeeTrainingViewModel()
            {
                AvailableTrainingPrograms = trainingOptions
            };
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AssignTraining(EmployeeTrainingViewModel employee)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {


                        cmd.CommandText = @"INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId)
                                            VALUES ";
                                            for (int index = 0; index < employee.TrainingProgramIds.Count; index++)
                                            {
                                            if (index == (employee.TrainingProgramIds.Count - 1))
                                            {
                                                cmd.CommandText += "(@employeeId, @trainingProgramId)";
                                            }
                                            else
                                            {
                                                cmd.CommandText += "(@employeeId, @trainingProgramId), ";
                                            }

                                            cmd.Parameters.Add(new SqlParameter("@trainingProgramId", employee.TrainingProgramIds.ElementAt(index)));
                                            }
                                            cmd.Parameters.Add(new SqlParameter("@employeeId", employee.Id));

                        cmd.ExecuteNonQuery();

                        return RedirectToAction(nameof(Details), new { id = employee.Id });

                        //INSERT INTO sales.promotions(
                        //    promotion_name,
                        //    discount,
                        //    start_date,
                        //    expired_date
                        //)
                        //VALUES
                        //    (
                        //        '2019 Summer Promotion',
                        //        0.15,
                        //        '20190601',
                        //        '20190901'
                        //    ),
                        //    (
                        //        '2019 Fall Promotion',
                        //        0.20,
                        //        '20191001',
                        //        '20191101'
                        //    )
                    }
                }


            }
            catch (Exception ex)
            {
                return View(employee);
            }
        }

        // GET: Employees/Edit/5
        public ActionResult Edit(int id)
        {
            var employee = GetEmployeeById(id);
            var departmentOptions = GetDepartmentOptions();
            var computerOptions = GetComputerOptions(id);
            var viewModel = new EmployeeViewModel()
            {
                Id = employee.Id,
                FirstName = employee.FirstName,
                LastName = employee.LastName,
                DepartmentId = employee.DepartmentId,
                Email = employee.Email,
                IsSupervisor = employee.IsSupervisor,
                ComputerId = employee.ComputerId,
                DepartmentOptions = departmentOptions,
                ComputerOptions = computerOptions
            };
            return View(viewModel);
        }

        // POST: Employees/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, EmployeeViewModel employee)
        {
            try
            {
                // TODO: Add update logic here
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @" UPDATE Employee
                                            SET FirstName = @firstName,
                                            LastName = lastName,
                                            DepartmentId = @departmentId,
                                            Email = @email,
                                            IsSupervisor = @isSupervisor,
                                            ComputerId = @computerId
                                            WHERE Id = @id";
                        cmd.Parameters.Add(new SqlParameter("@firstName", employee.FirstName));
                        cmd.Parameters.Add(new SqlParameter("@lastName", employee.LastName));
                        cmd.Parameters.Add(new SqlParameter("@departmentId", employee.DepartmentId));
                        cmd.Parameters.Add(new SqlParameter("@email", employee.Email));
                        cmd.Parameters.Add(new SqlParameter("@isSupervisor", employee.IsSupervisor));
                        cmd.Parameters.Add(new SqlParameter("@computerId", employee.ComputerId));
                        cmd.Parameters.Add(new SqlParameter("@id", id));

                        var rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected < 1)
                        {
                            return NotFound();
                        }
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        // GET: Employees/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Employees/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
        private List<SelectListItem> GetDepartmentOptions()
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT Id, Name FROM Department";

                    var reader = cmd.ExecuteReader();
                    var options = new List<SelectListItem>();

                    while (reader.Read())
                    {
                        var option = new SelectListItem()
                        {
                            Text = reader.GetString(reader.GetOrdinal("Name")),
                            Value = reader.GetInt32(reader.GetOrdinal("Id")).ToString()
                        };

                        options.Add(option);

                    }
                    reader.Close();
                    return options;
                }
            }
        }
        private List<SelectListItem> GetAvaialbleTrainingOptions(int? id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT tp.Id, tp.[Name], tp.StartDate, tp.EndDate, (tp.MaxAttendees - COUNT(et.EmployeeId)) AS AvailableSeats
                                      FROM TrainingProgram tp
                                      LEFT JOIN EmployeeTraining et ON et.TrainingProgramId = tp.Id
                                      LEFT JOIN Employee e ON et.EmployeeId = e.Id
                                      WHERE tp.StartDate > GetDate() AND(et.EmployeeId != @id OR et.EmployeeId IS NULL)
                                      GROUP BY tp.Id, tp.[Name], tp.StartDate, tp.EndDate, tp.MaxAttendees
                                      HAVING(tp.MaxAttendees - COUNT(et.EmployeeId)) > 0";
                    
                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();
                    var options = new List<SelectListItem>();

                    while (reader.Read())
                    {
                        var option = new SelectListItem()
                        {
                            Text = reader.GetString(reader.GetOrdinal("Name")),
                            Value = reader.GetInt32(reader.GetOrdinal("Id")).ToString()
                        };

                        options.Add(option);
                    }
                    reader.Close();
                    return options;
                }
            }
        }

        private List<SelectListItem> GetComputerOptions(int? id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT CONCAT(c.Make, ' ', c.Model) AS ComputerInfo, c.Id, e.FirstName FROM Computer c
                                        LEFT JOIN Employee e ON e.ComputerId = c.Id
                                        WHERE (c.DecomissionDate IS NULL AND e.ComputerId IS NULL)";
                    if (id != null)
                    {
                        cmd.CommandText += " OR e.Id =@id";
                        cmd.Parameters.Add(new SqlParameter("@id", id));
                    }

                    var reader = cmd.ExecuteReader();
                    var options = new List<SelectListItem>();

                    while (reader.Read())
                    {
                        var option = new SelectListItem()
                        {
                            Text = reader.GetString(reader.GetOrdinal("ComputerInfo")),
                            Value = reader.GetInt32(reader.GetOrdinal("Id")).ToString()
                        };

                        options.Add(option);

                    }
                    reader.Close();
                    return options;
                }
            }
        }

        private Employee GetEmployeeById(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT e.Id, e.FirstName, e.LastName, e.DepartmentId, e.Email, e.IsSupervisor, e.ComputerId, 
                                        d.[Name] AS DepartmentName, d.Budget, 
                                        c.PurchaseDate, c.DecomissionDate, c.Make, c.Model,
                                        tp.[Name] AS TrainingProgramName, tp.Id AS TrainingPId
                                        FROM Employee e
                                        LEFT JOIN Department d ON d.Id = e.DepartmentId
                                        LEFT JOIN Computer c ON c.Id = e.ComputerId
                                        LEFT JOIN EmployeeTraining et ON et.EmployeeId = e.Id
                                        LEFT JOIN TrainingProgram tp ON tp.Id=et.TrainingProgramId
                                        WHERE e.Id = @id";
                    cmd.Parameters.Add(new SqlParameter("@id", id));
                    var reader = cmd.ExecuteReader();
                    Employee employee = null;
                    while (reader.Read())
                    {
                        if (employee == null)
                        {
                            employee = new Employee
                            {
                                Id = reader.GetInt32(reader.GetOrdinal("Id")),
                                FirstName = reader.GetString(reader.GetOrdinal("FirstName")),
                                LastName = reader.GetString(reader.GetOrdinal("LastName")),
                                DepartmentId = reader.GetInt32(reader.GetOrdinal("DepartmentId")),
                                Department = new Department()
                                {
                                    Name = reader.GetString(reader.GetOrdinal("DepartmentName")),
                                    Budget = reader.GetInt32(reader.GetOrdinal("Budget"))
                                },
                                Email = reader.GetString(reader.GetOrdinal("Email")),
                                IsSupervisor = reader.GetBoolean(reader.GetOrdinal("IsSupervisor")),
                                ComputerId = reader.GetInt32(reader.GetOrdinal("ComputerId")),
                                Computer = new Computer()
                                {
                                    Id = reader.GetInt32(reader.GetOrdinal("Id")),
                                    PurchaseDate = reader.GetDateTime(reader.GetOrdinal("PurchaseDate")),
                                    Make = reader.GetString(reader.GetOrdinal("Make")),
                                    Model = reader.GetString(reader.GetOrdinal("Model"))
                                },
                                TrainingPrograms = new List<TrainingProgram>()
                            };
                        }
                        
                        if (!reader.IsDBNull(reader.GetOrdinal("TrainingProgramName")))
                        {
                            employee.TrainingPrograms.Add(new TrainingProgram()
                            {
                                Id = reader.GetInt32(reader.GetOrdinal("TrainingPId")),
                                Name = reader.GetString(reader.GetOrdinal("TrainingProgramName"))
                            }); 
                        }

                        if (!reader.IsDBNull(reader.GetOrdinal("DecomissionDate")))
                        {
                            employee.Computer.DecomissionDate = reader.GetDateTime(reader.GetOrdinal("DecomissionDate"));
                        }
                    }
                    reader.Close();
                    return employee;
                }
            }
        }

    }
}