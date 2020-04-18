using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BangazonWorkforce.Models.ViewModel
{
    public class EmployeeTrainingViewModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public List<int> TrainingProgramIds { get; set; }
        public EmployeeTrainingViewModel()
        {
            TrainingProgramIds = new List<int>();
        }
        public List<SelectListItem> AvailableTrainingPrograms { get; set; }              
    }
}
