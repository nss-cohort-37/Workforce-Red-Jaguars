﻿using System;
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
    public class ComputersController : Controller
    {
        private readonly IConfiguration _config;

        public ComputersController(IConfiguration config)
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

        // GET: Computers
        public ActionResult Index()
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT Id, PurchaseDate, DecomissionDate, Make, Model
                                        FROM Computer";

                    var reader = cmd.ExecuteReader();
                    var computers = new List<Computer>();

                    while (reader.Read())
                    {
                        var computer = new Computer()
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            PurchaseDate = reader.GetDateTime(reader.GetOrdinal("PurchaseDate")),
                            Make = reader.GetString(reader.GetOrdinal("Make")),
                            Model = reader.GetString(reader.GetOrdinal("Model"))
                        };

                        if (!reader.IsDBNull(reader.GetOrdinal("DecomissionDate")))
                        {
                            computer.DecomissionDate = reader.GetDateTime(reader.GetOrdinal("DecomissionDate"));
                        }

                        computers.Add(computer);
                    }
                    reader.Close();
                    return View(computers);
                }
            }
        }

        // GET: Computers/Details/5
        public ActionResult Details(int id)
        {
            var computer = GetComputerById(id);
            return View(computer);
        }

        // GET: Computers/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Computers/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Computer computer)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @"INSERT INTO Computer (Make, Model, PurchaseDate)
                                            OUTPUT INSERTED.Id
                                            VALUES (@make, @model, @purchaseDate)";

                        cmd.Parameters.Add(new SqlParameter("@make", computer.Make));
                        cmd.Parameters.Add(new SqlParameter("@model", computer.Model));
                        cmd.Parameters.Add(new SqlParameter("@purchaseDate", computer.PurchaseDate));

                        var id = (int)cmd.ExecuteScalar();
                        computer.Id = id;

                        return RedirectToAction(nameof(Index));
                    }
                }


            }
            catch (Exception ex)
            {
                return View(computer);
            }
        }

        // GET: Computers/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Computers/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: Computers/Delete/5
        public ActionResult Delete(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT c.Id, c.PurchaseDate, c.DecomissionDate, c.Make, c.Model, e.Id AS EmployeeId
                                        FROM Computer c
                                        LEFT JOIN Employee e ON c.Id = e.ComputerId
                                        WHERE c.Id = @id";

                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();
                    Computer computer = null;

                    if (reader.Read())
                    {
                        if (!reader.IsDBNull(reader.GetOrdinal("EmployeeId")))
                        {
                            return NotFound();
                        }

                        computer = new Computer
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            PurchaseDate = reader.GetDateTime(reader.GetOrdinal("PurchaseDate")),
                            Make = reader.GetString(reader.GetOrdinal("Make")),
                            Model = reader.GetString(reader.GetOrdinal("Model"))
                        };

                        if (!reader.IsDBNull(reader.GetOrdinal("DecomissionDate")))
                        {
                            computer.DecomissionDate = reader.GetDateTime(reader.GetOrdinal("DecomissionDate"));
                        }
                    }
                    reader.Close();
                    return View(computer);
                }
            }
        }

        // POST: Computers/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, Computer computer)
        {
            try
            {
                using (SqlConnection conn = Connection)
                {
                    conn.Open();
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = @"DELETE FROM Computer WHERE Id = @id";
                        cmd.Parameters.Add(new SqlParameter("@id", id));

                        cmd.ExecuteNonQuery();
                    }
                }

                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                return View(computer);
            }
        }

        private ComputerViewModel GetComputerById(int id)
        {
            using (SqlConnection conn = Connection)
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"SELECT c.Id, c.PurchaseDate, c.DecomissionDate, c.Make, c.Model, e.Id AS EmployeeId
                                        FROM Computer c
                                        LEFT JOIN Employee e
                                        ON c.Id = e.ComputerId
                                        WHERE c.Id = @id";

                    cmd.Parameters.Add(new SqlParameter("@id", id));

                    var reader = cmd.ExecuteReader();
                    ComputerViewModel computer = null;

                    if (reader.Read())
                    {
                        computer = new ComputerViewModel
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("Id")),
                            PurchaseDate = reader.GetDateTime(reader.GetOrdinal("PurchaseDate")),
                            Make = reader.GetString(reader.GetOrdinal("Make")),
                            Model = reader.GetString(reader.GetOrdinal("Model"))
                        };

                        if (!reader.IsDBNull(reader.GetOrdinal("DecomissionDate")))
                        {
                            computer.DecomissionDate = reader.GetDateTime(reader.GetOrdinal("DecomissionDate"));
                        }

                        if (!reader.IsDBNull(reader.GetOrdinal("EmployeeId")))
                        {
                            computer.EmployeeId = reader.GetInt32(reader.GetOrdinal("EmployeeId"));
                        }
                    }
                    reader.Close();
                    return computer;
                }
            }
        }
    }
}