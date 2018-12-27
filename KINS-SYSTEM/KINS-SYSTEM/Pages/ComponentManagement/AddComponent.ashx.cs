using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// AddComponent1 的摘要说明
    /// </summary>
    public class AddComponent1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(addComponent(data));
        }

        private int addComponent(Data data)
        {
            string sqlStr = "";
            DbSql ds = new DbSql();
            sqlStr = "INSERT INTO K_Component (Cp_typeId, Cp_manufacturerId, Cp_parameter,  Cp_price, Cp_unit, Cp_inventory, Cp_remarks, Cp_pictrue,Cp_company) VALUES ('" +
                data.Cp_typeId + "', '" + data.Cp_manufacturerId + "', '" + data.Cp_parameter +  "', '" + Double.Parse(0+data.Cp_price) + "','" + data.Cp_unit + "', '" + Double.Parse(0+data.Cp_inventory) + "','" + data.Cp_remarks + "','" + data.Cp_pictrue + "','" + data.company + "')";
            if (!ds.ExecSql(sqlStr))
                return 0;
            return 2;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string Cp_typeId, Cp_manufacturerId, Cp_parameter, Cp_name, Cp_price, Cp_unit, Cp_inventory, Cp_remarks, Cp_pictrue,company="";
        }
    }
}