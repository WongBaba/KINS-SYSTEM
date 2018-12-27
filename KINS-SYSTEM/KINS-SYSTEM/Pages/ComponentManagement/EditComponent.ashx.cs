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

namespace KINS_SYSTEM.Pages.ComponentManagement
{
    /// <summary>
    /// EditComponent1 的摘要说明
    /// </summary>
    public class EditComponent1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            context.Response.Write(addComponent(data));
        }

        private int addComponent(Data data)
        {
            //返回2代表修改成功，返回0代表数据库添加失败

            string sqlStr = "UPDATE K_Component SET Cp_typeId='" + data.Cp_typeId + "', Cp_manufacturerId= '" + data.Cp_manufacturerId + "',Cp_parameter= '" + data.Cp_parameter  + "',Cp_price= '" + Double.Parse(data.Cp_price) + "',Cp_unit='" + data.Cp_unit + "',Cp_inventory= '" + Double.Parse(data.Cp_inventory) + "',Cp_remarks='" + data.Cp_remarks + "',Cp_pictrue='" + data.Cp_pictrue + "' WHERE Cp_id='"+data.Cp_id+"'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
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
            public string Cp_typeId, Cp_manufacturerId, Cp_parameter, Cp_price, Cp_unit, Cp_inventory, Cp_remarks, Cp_pictrue, Cp_id;
        }
    }
}