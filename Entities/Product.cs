using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace Entities
{
    [Table("Product")]
    [Index(nameof(Name), Name = "IX_Product_Name")]
    [Index(nameof(Code), Name = "IX_Unique_Product_Code", IsUnique = true)]
    public partial class Product
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Code { get; set; }
        [Required]
        [StringLength(150)]
        public string Name { get; set; }
        public int SupplierId { get; set; }
        public DateTime Created { get; set; }
        public DateTime LastModified { get; set; }

        [ForeignKey(nameof(SupplierId))]
        [InverseProperty("Products")]
        public virtual Supplier Supplier { get; set; }
    }
}
