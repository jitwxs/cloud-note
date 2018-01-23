package cn.edu.jit.entry;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LoginByThirdExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public LoginByThirdExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    public boolean isDistinct() {
        return distinct;
    }

    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andIdIsNull() {
            addCriterion("id is null");
            return (Criteria) this;
        }

        public Criteria andIdIsNotNull() {
            addCriterion("id is not null");
            return (Criteria) this;
        }

        public Criteria andIdEqualTo(String value) {
            addCriterion("id =", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotEqualTo(String value) {
            addCriterion("id <>", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThan(String value) {
            addCriterion("id >", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdGreaterThanOrEqualTo(String value) {
            addCriterion("id >=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThan(String value) {
            addCriterion("id <", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLessThanOrEqualTo(String value) {
            addCriterion("id <=", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdLike(String value) {
            addCriterion("id like", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotLike(String value) {
            addCriterion("id not like", value, "id");
            return (Criteria) this;
        }

        public Criteria andIdIn(List<String> values) {
            addCriterion("id in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotIn(List<String> values) {
            addCriterion("id not in", values, "id");
            return (Criteria) this;
        }

        public Criteria andIdBetween(String value1, String value2) {
            addCriterion("id between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andIdNotBetween(String value1, String value2) {
            addCriterion("id not between", value1, value2, "id");
            return (Criteria) this;
        }

        public Criteria andThirdTypeIsNull() {
            addCriterion("third_type is null");
            return (Criteria) this;
        }

        public Criteria andThirdTypeIsNotNull() {
            addCriterion("third_type is not null");
            return (Criteria) this;
        }

        public Criteria andThirdTypeEqualTo(String value) {
            addCriterion("third_type =", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeNotEqualTo(String value) {
            addCriterion("third_type <>", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeGreaterThan(String value) {
            addCriterion("third_type >", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeGreaterThanOrEqualTo(String value) {
            addCriterion("third_type >=", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeLessThan(String value) {
            addCriterion("third_type <", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeLessThanOrEqualTo(String value) {
            addCriterion("third_type <=", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeLike(String value) {
            addCriterion("third_type like", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeNotLike(String value) {
            addCriterion("third_type not like", value, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeIn(List<String> values) {
            addCriterion("third_type in", values, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeNotIn(List<String> values) {
            addCriterion("third_type not in", values, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeBetween(String value1, String value2) {
            addCriterion("third_type between", value1, value2, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdTypeNotBetween(String value1, String value2) {
            addCriterion("third_type not between", value1, value2, "thirdType");
            return (Criteria) this;
        }

        public Criteria andThirdIdIsNull() {
            addCriterion("third_id is null");
            return (Criteria) this;
        }

        public Criteria andThirdIdIsNotNull() {
            addCriterion("third_id is not null");
            return (Criteria) this;
        }

        public Criteria andThirdIdEqualTo(String value) {
            addCriterion("third_id =", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdNotEqualTo(String value) {
            addCriterion("third_id <>", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdGreaterThan(String value) {
            addCriterion("third_id >", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdGreaterThanOrEqualTo(String value) {
            addCriterion("third_id >=", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdLessThan(String value) {
            addCriterion("third_id <", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdLessThanOrEqualTo(String value) {
            addCriterion("third_id <=", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdLike(String value) {
            addCriterion("third_id like", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdNotLike(String value) {
            addCriterion("third_id not like", value, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdIn(List<String> values) {
            addCriterion("third_id in", values, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdNotIn(List<String> values) {
            addCriterion("third_id not in", values, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdBetween(String value1, String value2) {
            addCriterion("third_id between", value1, value2, "thirdId");
            return (Criteria) this;
        }

        public Criteria andThirdIdNotBetween(String value1, String value2) {
            addCriterion("third_id not between", value1, value2, "thirdId");
            return (Criteria) this;
        }

        public Criteria andUserIdIsNull() {
            addCriterion("user_id is null");
            return (Criteria) this;
        }

        public Criteria andUserIdIsNotNull() {
            addCriterion("user_id is not null");
            return (Criteria) this;
        }

        public Criteria andUserIdEqualTo(String value) {
            addCriterion("user_id =", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdNotEqualTo(String value) {
            addCriterion("user_id <>", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdGreaterThan(String value) {
            addCriterion("user_id >", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdGreaterThanOrEqualTo(String value) {
            addCriterion("user_id >=", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdLessThan(String value) {
            addCriterion("user_id <", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdLessThanOrEqualTo(String value) {
            addCriterion("user_id <=", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdLike(String value) {
            addCriterion("user_id like", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdNotLike(String value) {
            addCriterion("user_id not like", value, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdIn(List<String> values) {
            addCriterion("user_id in", values, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdNotIn(List<String> values) {
            addCriterion("user_id not in", values, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdBetween(String value1, String value2) {
            addCriterion("user_id between", value1, value2, "userId");
            return (Criteria) this;
        }

        public Criteria andUserIdNotBetween(String value1, String value2) {
            addCriterion("user_id not between", value1, value2, "userId");
            return (Criteria) this;
        }

        public Criteria andUselessPwdIsNull() {
            addCriterion("useless_pwd is null");
            return (Criteria) this;
        }

        public Criteria andUselessPwdIsNotNull() {
            addCriterion("useless_pwd is not null");
            return (Criteria) this;
        }

        public Criteria andUselessPwdEqualTo(String value) {
            addCriterion("useless_pwd =", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdNotEqualTo(String value) {
            addCriterion("useless_pwd <>", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdGreaterThan(String value) {
            addCriterion("useless_pwd >", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdGreaterThanOrEqualTo(String value) {
            addCriterion("useless_pwd >=", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdLessThan(String value) {
            addCriterion("useless_pwd <", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdLessThanOrEqualTo(String value) {
            addCriterion("useless_pwd <=", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdLike(String value) {
            addCriterion("useless_pwd like", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdNotLike(String value) {
            addCriterion("useless_pwd not like", value, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdIn(List<String> values) {
            addCriterion("useless_pwd in", values, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdNotIn(List<String> values) {
            addCriterion("useless_pwd not in", values, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdBetween(String value1, String value2) {
            addCriterion("useless_pwd between", value1, value2, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andUselessPwdNotBetween(String value1, String value2) {
            addCriterion("useless_pwd not between", value1, value2, "uselessPwd");
            return (Criteria) this;
        }

        public Criteria andCreateDateIsNull() {
            addCriterion("create_date is null");
            return (Criteria) this;
        }

        public Criteria andCreateDateIsNotNull() {
            addCriterion("create_date is not null");
            return (Criteria) this;
        }

        public Criteria andCreateDateEqualTo(Date value) {
            addCriterion("create_date =", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateNotEqualTo(Date value) {
            addCriterion("create_date <>", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateGreaterThan(Date value) {
            addCriterion("create_date >", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateGreaterThanOrEqualTo(Date value) {
            addCriterion("create_date >=", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateLessThan(Date value) {
            addCriterion("create_date <", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateLessThanOrEqualTo(Date value) {
            addCriterion("create_date <=", value, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateIn(List<Date> values) {
            addCriterion("create_date in", values, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateNotIn(List<Date> values) {
            addCriterion("create_date not in", values, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateBetween(Date value1, Date value2) {
            addCriterion("create_date between", value1, value2, "createDate");
            return (Criteria) this;
        }

        public Criteria andCreateDateNotBetween(Date value1, Date value2) {
            addCriterion("create_date not between", value1, value2, "createDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateIsNull() {
            addCriterion("modifed_date is null");
            return (Criteria) this;
        }

        public Criteria andModifedDateIsNotNull() {
            addCriterion("modifed_date is not null");
            return (Criteria) this;
        }

        public Criteria andModifedDateEqualTo(Date value) {
            addCriterion("modifed_date =", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateNotEqualTo(Date value) {
            addCriterion("modifed_date <>", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateGreaterThan(Date value) {
            addCriterion("modifed_date >", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateGreaterThanOrEqualTo(Date value) {
            addCriterion("modifed_date >=", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateLessThan(Date value) {
            addCriterion("modifed_date <", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateLessThanOrEqualTo(Date value) {
            addCriterion("modifed_date <=", value, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateIn(List<Date> values) {
            addCriterion("modifed_date in", values, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateNotIn(List<Date> values) {
            addCriterion("modifed_date not in", values, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateBetween(Date value1, Date value2) {
            addCriterion("modifed_date between", value1, value2, "modifedDate");
            return (Criteria) this;
        }

        public Criteria andModifedDateNotBetween(Date value1, Date value2) {
            addCriterion("modifed_date not between", value1, value2, "modifedDate");
            return (Criteria) this;
        }
    }

    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}