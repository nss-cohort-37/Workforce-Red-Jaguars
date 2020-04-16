using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BangazonWorkforce.Models;
using BangazonWorkforce.Models.ViewModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace BangazonWorkforce.Controllers
{
    public class TrainingProgramsController : Controller
    {
        private readonly IConfiguration _config;

        public TrainingProgramsController(IConfiguration config)
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

        // GET: TrainingPrograms
        public ActionResult Index()
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT Id, Name, StartDate, EndDate, MaxAttendees
                                        FROM TrainingProgram
                                        WHERE StartDate > GetDate()";

                    var reader = cmd.ExecuteReader();
                    var trainingPrograms = new List<TrainingProgram>();

                    while (reader.Read())
                    {
                        var trainingProgram = new TrainingProgram()
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            Name = reader.GetString(reader.GetOrdinal("Name")),
                            StartDate = reader.GetDateTime(reader.GetOrdinal("StartDate")),
                            EndDate = reader.GetDateTime(reader.GetOrdinal("EndDate")),
                            MaxAttendees = reader.GetInt32(reader.GetOrdinal("MaxAttendees"))
                        };
                        trainingPrograms.Add(trainingProgram);
                    }
                    reader.Close();
                    return View(trainingPrograms);
                }
            }
        }

        // GET: TrainingPrograms/Details/5
        public ActionResult Details(int id)
        {
            return View(GetTrainingProgramViewModel(id));
        }

        // GET: TrainingPrograms/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: TrainingPrograms/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(TrainingProgram trainingProgram)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @"INSERT INTO TrainingProgram ([Name], StartDate, EndDate, MaxAttendees)
                                            OUTPUT INSERTED.Id
                                            VALUES (@name, @startDate, @endDate, @maxAttendees)";

                        cmd.Parameters.Add(new SqlParameter("@name", trainingProgram.Name));
                        cmd.Parameters.Add(new SqlParameter("@startDate", trainingProgram.StartDate));
                        cmd.Parameters.Add(new SqlParameter("@endDate", trainingProgram.EndDate));
                        cmd.Parameters.Add(new SqlParameter("@maxAttendees", trainingProgram.MaxAttendees));

                        var id = (int)cmd.ExecuteScalar();
                        trainingProgram.Id = id;

                        return RedirectToAction(nameof(Index));
                    }
                }
            }
            catch
            {
                return View();
            }
        }

        // GET: TrainingPrograms/Edit/5
        public ActionResult Edit(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT Id, Name, StartDate, EndDate, MaxAttendees FROM TrainingProgram  
                                        WHERE Id = @id";

                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();
                    DateTime DateTimeNow = DateTime.Now
;
                    TrainingProgram trainingProgram = null;

                    if (reader.Read())
                    {
                        if (reader.GetDateTime(reader.GetOrdinal("StartDate")) < DateTimeNow)
                        {
                            return NotFound();
                        }

                        trainingProgram = new TrainingProgram()
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            Name = reader.GetString(reader.GetOrdinal("Name")),
                            StartDate = reader.GetDateTime(reader.GetOrdinal("StartDate")),
                            EndDate = reader.GetDateTime(reader.GetOrdinal("EndDate")),
                            MaxAttendees = reader.GetInt32(reader.GetOrdinal("MaxAttendees"))
                        };

                    }
                    reader.Close();
                    if (trainingProgram == null)
                    {
                        return NotFound();
                    }
                    else
                    {
                        return View(trainingProgram);
                    }
                }
            }
        }

        // POST: TrainingPrograms/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, TrainingProgram trainingProgram)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @" UPDATE TrainingProgram
                                            SET Name = @name,
                                            StartDate = @startDate,
                                            EndDate = @endDate,
                                            MaxAttendees = @maxAttendees
                                            WHERE Id = @id";
                        cmd.Parameters.Add(new SqlParameter("@name", trainingProgram.Name));
                        cmd.Parameters.Add(new SqlParameter("@startDate", trainingProgram.StartDate));
                        cmd.Parameters.Add(new SqlParameter("@endDate", trainingProgram.EndDate));
                        cmd.Parameters.Add(new SqlParameter("@maxAttendees", trainingProgram.MaxAttendees));
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
            catch
            {
                return View();
            }
        }

        // GET: TrainingPrograms/Delete/5
        public ActionResult Delete(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT Id, Name, StartDate, EndDate, MaxAttendees
                                        FROM TrainingProgram
                                        WHERE Id = @id";

                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();
                    DateTime DateTimeNow = DateTime.Now;
                    TrainingProgram trainingProgram = null;

                    if (reader.Read())
                    {
                        if (reader.IsDBNull(reader.GetOrdinal("Id")))
                        {
                            return NotFound();
                        }
                        else if (reader.GetDateTime(reader.GetOrdinal("StartDate")) < DateTimeNow)
                        {
                            return NotFound();
                        }

                        trainingProgram = new TrainingProgram
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            Name = reader.GetString(reader.GetOrdinal("Name")),
                            StartDate = reader.GetDateTime(reader.GetOrdinal("StartDate")),
                            EndDate = reader.GetDateTime(reader.GetOrdinal("EndDate")),
                            MaxAttendees = reader.GetInt32(reader.GetOrdinal("MaxAttendees"))
                        };
                    }
                    reader.Close();
                    if (trainingProgram == null)
                    {
                        return NotFound();
                    }
                    else
                    {
                        return View(trainingProgram);
                    }
                }
            }
        }

        // POST: TrainingPrograms/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, TrainingProgram trainginProgram)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @"DELETE FROM TrainingProgram WHERE Id = @id";
                        cmd.Parameters.Add(new SqlParameter("@id", id));

                        cmd.ExecuteNonQuery();
                    }
                }

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                return View(trainginProgram);
            }
        }

        private TrainingProgramViewModel GetTrainingProgramViewModel(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT tp.Id, tp.Name, tp.StartDate, tp.EndDate, tp.MaxAttendees,
                                        e.Id AS EmployeeId, e.FirstName, e.LastName, e.DepartmentId, e.Email, e.IsSupervisor, e.ComputerId
                                        FROM TrainingProgram tp
                                        LEFT JOIN EmployeeTraining et ON et.TrainingProgramId = tp.Id
                                        LEFT JOIN Employee e ON et.EmployeeId = e.Id
                                        WHERE tp.Id = @id";
                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();

                    TrainingProgramViewModel trainingProgram = null;

                    while (reader.Read())
                    {
                        if (trainingProgram == null)
                        {
                            trainingProgram = new TrainingProgramViewModel
                            {
                                Id = reader.GetInt32(reader.GetOrdinal("Id")),
                                Name = reader.GetString(reader.GetOrdinal("Name")),
                                StartDate = reader.GetDateTime(reader.GetOrdinal("StartDate")),
                                EndDate = reader.GetDateTime(reader.GetOrdinal("EndDate")),
                                MaxAttendees = reader.GetInt32(reader.GetOrdinal("MaxAttendees")),
                                Employees = new List<Employee>()
                            };
                        }

                        trainingProgram.Employees.Add(new Employee()
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("EmployeeId")),
                            FirstName = reader.GetString(reader.GetOrdinal("FirstName")),
                            LastName = reader.GetString(reader.GetOrdinal("LastName")),
                            DepartmentId = reader.GetInt32(reader.GetOrdinal("DepartmentId")),
                            Email = reader.GetString(reader.GetOrdinal("Email")),
                            IsSupervisor = reader.GetBoolean(reader.GetOrdinal("IsSupervisor")),
                            ComputerId = reader.GetInt32(reader.GetOrdinal("ComputerId"))
                        });
                    }
                    reader.Close();

                    return trainingProgram;
                }
            }
        }
    }
}