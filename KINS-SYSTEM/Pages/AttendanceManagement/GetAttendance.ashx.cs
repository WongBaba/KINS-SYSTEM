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
using System.Web.SessionState;

namespace KINS_SYSTEM.Pages.AttendanceManagement
{
    /// <summary>
    /// GetAttendance 的摘要说明
    /// </summary>
    public class GetAttendance : IHttpHandler,System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            context.Response.Write(getAttData(data));
        }

        private string getAttData(Data data) {
            DateTime dt =  Convert.ToDateTime(data.year+"-"+data.month+"-01");
            DateTime dt2 = dt.AddMonths(1);
            string sqlStr = "select * from K_onoffDutyData where O_employeeId='" + HttpContext.Current.Session["yhm"] + "' and O_checkDate>='" + dt + "' and O_checkDate<'" + dt2 + "'  order by O_checkDate desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Columns.Add("workTime", typeof(long));
            da.Columns.Add("exTime", typeof(long));
            for (int i = 0; i < da.Rows.Count; i++) {
                long temp = 0;
                if (da.Rows[i]["O_onDuty1"].ToString() != "" && da.Rows[i]["O_offDuty1"].ToString() != "") { 
                    TimeSpan ts=DateTime.Parse(da.Rows[i]["O_offDuty1"].ToString())-DateTime.Parse(da.Rows[i]["O_onDuty1"].ToString());
                    temp += (long)ts.TotalMinutes;
                }
                if (da.Rows[i]["O_onDuty2"].ToString() != "" && da.Rows[i]["O_offDuty2"].ToString() != "")
                {
                    TimeSpan ts = DateTime.Parse(da.Rows[i]["O_offDuty2"].ToString()) - DateTime.Parse(da.Rows[i]["O_onDuty2"].ToString());
                    temp += (long)ts.TotalMinutes;
                }
                da.Rows[i]["workTime"] = temp;
                temp = 0;
                if (da.Rows[i]["O_onDuty3"].ToString() != "" && da.Rows[i]["O_offDuty3"].ToString() != "")
                {
                    TimeSpan ts = DateTime.Parse(da.Rows[i]["O_offDuty3"].ToString()) - DateTime.Parse(da.Rows[i]["O_onDuty3"].ToString());
                    temp += (long)ts.TotalMinutes;
                }
                da.Rows[i]["exTime"] = temp;
            }
            long allTime = 0;
            long exTime = 0;
            long lostTime = 0;
            for (int i = 0; i < da.Rows.Count; i++) {
                allTime += (long)da.Rows[i]["workTime"] + (long)da.Rows[i]["exTime"];
                if ((long)da.Rows[i]["workTime"] < 570 && DateTime.Now > DateTime.Parse(da.Rows[i]["O_checkDate"].ToString()).AddHours(19.01))
                {
                    lostTime += 570 - (long)da.Rows[i]["workTime"];
                }
                exTime += (long)da.Rows[i]["exTime"];
            }
            da.Rows.Add();
            da.Rows[da.Rows.Count-1][0] = allTime + "@" + lostTime + "@" + exTime + "";
                return (JsonConvert.SerializeObject(da, new DataTableConverter()));
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
            public string year = "";
            public string month = "";
        }
    }
}