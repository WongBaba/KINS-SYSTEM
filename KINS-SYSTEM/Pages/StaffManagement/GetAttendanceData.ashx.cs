using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.StaffManagement
{
    /// <summary>
    /// GetAttendanceData 的摘要说明
    /// </summary>
    public class GetAttendanceData : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(getData(data));
        }
        private string getData(Data data)
        {
            string sqlStr = " select top 200 Emp_id,Emp_name,O_checkDate,O_onDuty1,O_onDuty2,O_onDuty3,O_offDuty1,O_offDuty2,O_offDuty3 from K_Employee,K_onoffDutyData where O_employeeId=Emp_id and Emp_company='"+data.company+"' ";
            sqlStr += getSqlStr(data);
            sqlStr += " and Emp_id not in ( select top " + (data.starCom - 1) + " Emp_id from  K_Employee,K_onoffDutyData where O_employeeId=Emp_id and Emp_company='" + data.company + "' " + getSqlStr(data) + " order  by O_checkDate desc,Emp_id desc)";
            sqlStr += "  order by O_checkDate desc,Emp_id desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Rows.Add(da);                //将这一行记录加这个表中
            sqlStr = "select count (*) from K_Employee,K_onoffDutyData where O_employeeId=Emp_id " + getSqlStr(data);
            string temp = ds.FillDt(sqlStr).Rows[0][0].ToString();
            DataRow row = da.NewRow();
            row["Emp_id"] = temp;
            da.Rows.Add(row);
            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
        }

        private string getSqlStr(Data data)
        {
            string sqlStr = "";
            if (data.Emp_state != "")
                sqlStr += " and Emp_state = '" + data.Emp_state + "'";
            if (data.Emp_deptId != "")
                sqlStr += " and Emp_deptId = '" + data.Emp_deptId + "'";
            if (data.Emp_positionId != "")
                sqlStr += " and Emp_positionId = '" + data.Emp_positionId + "'";
            if (data.Emp_id != "")
                sqlStr += " and Emp_id like '%" + data.Emp_id + "%'";
            if (data.Emp_name != "")
                sqlStr += " and Emp_name like '%" + data.Emp_name + "%'";
            if (data.O_checkDate != "")
                sqlStr += " and O_checkDate = '" + data.O_checkDate + "'";
            return sqlStr;
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
            public string Emp_state = "", Emp_deptId = "", Emp_positionId = "", Emp_id = "", Emp_name = "", O_checkDate = "",company="";
            public int starCom;
        }
    }
}