--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2021-12-12 23:32:26

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 239 (class 1255 OID 26850)
-- Name: addleasedcarstotal(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addleasedcarstotal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update totals set total_leased_cars = total_leased_cars + 1;
return new;
end;
$$;


ALTER FUNCTION public.addleasedcarstotal() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 26859)
-- Name: all_leased_insert_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.all_leased_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    payment integer;
BEGIN
	payment:=(select rent_payment from on_rent WHERE rent_id = new.rent_id);
    INSERT INTO payments(rent_id, payment,payment_date)
    VALUES(new.rent_id ,payment,now());
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.all_leased_insert_trigger() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 26858)
-- Name: allleasedcars(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.allleasedcars() RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
declare 
delivery_date TIMESTAMP;
begin 
INSERT INTO all_leased_cars (rent_id)
SELECT on_rent.rent_id
FROM on_rent
WHERE on_rent.delivery_date < now();

return delivery_date;
end;
$$;


ALTER FUNCTION public.allleasedcars() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 26861)
-- Name: getbrandsinfo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getbrandsinfo() RETURNS TABLE(brand_id integer, brand_name character varying)
    LANGUAGE plpgsql
    AS $$
begin 
RETURN QUERY
SELECT * FROM brands;
end;
$$;


ALTER FUNCTION public.getbrandsinfo() OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 26856)
-- Name: getcarsinfo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getcarsinfo() RETURNS TABLE(car_id integer, price character varying, fuel character varying, type character varying, gear character varying, seat character varying, brand_id integer, model_id integer, dealer_id integer, image_url character varying, brand_name character varying, model_name character varying)
    LANGUAGE plpgsql
    AS $$
begin 
RETURN QUERY
SELECT cars.car_id, cars.price, cars.fuel, cars.type, cars.gear, cars.seat, cars.brand_id, cars.model_id, cars.dealer_id, cars.image_url, brands.brand_name, models.model_name  
FROM cars LEFT JOIN on_rent ON cars.car_id = on_rent.car_id 
INNER JOIN brands ON cars.brand_id = brands.brand_id 
INNER JOIN models ON cars.model_id = models.model_id 
WHERE on_rent.car_id IS NULL;
end;
$$;


ALTER FUNCTION public.getcarsinfo() OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 26857)
-- Name: getleasedcarsinfo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getleasedcarsinfo() RETURNS TABLE(car_id integer, day integer, rent_payment integer, reception_date timestamp without time zone, delivery_date timestamp without time zone, fuel character varying, type character varying, gear character varying, seat character varying, image_url character varying, price character varying, brand_name character varying, model_name character varying)
    LANGUAGE plpgsql
    AS $$
begin 
RETURN QUERY
SELECT on_rent.car_id, on_rent.day, on_rent.rent_payment, on_rent.reception_date, on_rent.delivery_date, cars.fuel, cars.type, cars.gear, cars.seat, cars.image_url, cars.price, brands.brand_name, models.model_name  
FROM on_rent
LEFT JOIN cars ON cars.car_id = on_rent.car_id
LEFT JOIN brands ON cars.brand_id = brands.brand_id 
LEFT JOIN models ON cars.model_id = models.model_id; 
end;
$$;


ALTER FUNCTION public.getleasedcarsinfo() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 26852)
-- Name: totalpayments(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalpayments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
last_payment integer;
begin 
last_payment:=(select payment from payments order by payment_id desc limit 1);
update totals set total_payment = total_payment + last_payment;
return new;
end;
$$;


ALTER FUNCTION public.totalpayments() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 26854)
-- Name: totalsalaries(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalsalaries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
total_salary integer;
begin 
total_salary:=(select sum(salary) from employees);
update totals set total_employee_salary = total_salary;
return new;
end;
$$;


ALTER FUNCTION public.totalsalaries() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 26784)
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    address_id integer NOT NULL,
    address character varying(100),
    user_id integer
);


ALTER TABLE public.address OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26783)
-- Name: address_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.address_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_address_id_seq OWNER TO postgres;

--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 227
-- Name: address_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.address_address_id_seq OWNED BY public.address.address_id;


--
-- TOC entry 238 (class 1259 OID 26839)
-- Name: all_leased_cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.all_leased_cars (
    leased_id integer NOT NULL,
    rent_id integer
);


ALTER TABLE public.all_leased_cars OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 26838)
-- Name: all_leased_cars_leased_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.all_leased_cars_leased_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.all_leased_cars_leased_id_seq OWNER TO postgres;

--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 237
-- Name: all_leased_cars_leased_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.all_leased_cars_leased_id_seq OWNED BY public.all_leased_cars.leased_id;


--
-- TOC entry 218 (class 1259 OID 26707)
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    brand_id integer NOT NULL,
    brand_name character varying(40)
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26706)
-- Name: brands_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brands_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brands_brand_id_seq OWNER TO postgres;

--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 217
-- Name: brands_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brands_brand_id_seq OWNED BY public.brands.brand_id;


--
-- TOC entry 222 (class 1259 OID 26726)
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    car_id integer NOT NULL,
    price character varying(20) NOT NULL,
    fuel character varying(30),
    type character varying(10),
    gear character varying(10),
    seat character varying(20),
    image_url character varying,
    brand_id integer,
    model_id integer,
    dealer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 26725)
-- Name: cars_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cars_car_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cars_car_id_seq OWNER TO postgres;

--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 221
-- Name: cars_car_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cars_car_id_seq OWNED BY public.cars.car_id;


--
-- TOC entry 214 (class 1259 OID 26688)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    city_id integer NOT NULL,
    name character varying(20)
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 26687)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_city_id_seq OWNER TO postgres;

--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 213
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_city_id_seq OWNED BY public.cities.city_id;


--
-- TOC entry 216 (class 1259 OID 26695)
-- Name: dealers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealers (
    dealer_id integer NOT NULL,
    dealer_name character varying(50),
    city_id integer
);


ALTER TABLE public.dealers OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 26694)
-- Name: dealers_dealer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dealers_dealer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dealers_dealer_id_seq OWNER TO postgres;

--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 215
-- Name: dealers_dealer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dealers_dealer_id_seq OWNED BY public.dealers.dealer_id;


--
-- TOC entry 232 (class 1259 OID 26808)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying(20),
    last_name character varying(25),
    email character varying(25),
    phone_number character varying(11),
    hire_date timestamp without time zone,
    salary numeric(8,2),
    dealer_id integer
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26807)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employee_id_seq OWNER TO postgres;

--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 231
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 220 (class 1259 OID 26714)
-- Name: models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models (
    model_id integer NOT NULL,
    model_name character varying(40),
    brand_id integer
);


ALTER TABLE public.models OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 26713)
-- Name: models_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.models_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.models_model_id_seq OWNER TO postgres;

--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 219
-- Name: models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.models_model_id_seq OWNED BY public.models.model_id;


--
-- TOC entry 224 (class 1259 OID 26750)
-- Name: on_rent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.on_rent (
    rent_id integer NOT NULL,
    day integer,
    reception_date timestamp without time zone NOT NULL,
    delivery_date timestamp without time zone NOT NULL,
    user_id integer,
    car_id integer,
    dealer_id integer,
    rent_payment integer
);


ALTER TABLE public.on_rent OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26749)
-- Name: on_rent_rent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.on_rent_rent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.on_rent_rent_id_seq OWNER TO postgres;

--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 223
-- Name: on_rent_rent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.on_rent_rent_id_seq OWNED BY public.on_rent.rent_id;


--
-- TOC entry 234 (class 1259 OID 26820)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    payment integer,
    rent_id integer,
    payment_date timestamp without time zone NOT NULL
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 26819)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 233
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 226 (class 1259 OID 26772)
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone_numbers (
    number_id integer NOT NULL,
    number character varying(11),
    user_id integer
);


ALTER TABLE public.phone_numbers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26771)
-- Name: phone_numbers_number_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phone_numbers_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phone_numbers_number_id_seq OWNER TO postgres;

--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 225
-- Name: phone_numbers_number_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phone_numbers_number_id_seq OWNED BY public.phone_numbers.number_id;


--
-- TOC entry 210 (class 1259 OID 26667)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role character varying(10)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 26666)
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_role_id_seq OWNER TO postgres;

--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 209
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- TOC entry 236 (class 1259 OID 26832)
-- Name: totals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.totals (
    id integer NOT NULL,
    total_payment integer,
    total_employee_salary integer,
    total_leased_cars integer
);


ALTER TABLE public.totals OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 26831)
-- Name: totals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.totals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.totals_id_seq OWNER TO postgres;

--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 235
-- Name: totals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.totals_id_seq OWNED BY public.totals.id;


--
-- TOC entry 230 (class 1259 OID 26796)
-- Name: user_payment_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_payment_info (
    user_payment_id integer NOT NULL,
    card_number character varying(12),
    user_id integer
);


ALTER TABLE public.user_payment_info OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 26795)
-- Name: user_payment_info_user_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_payment_info_user_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_payment_info_user_payment_id_seq OWNER TO postgres;

--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 229
-- Name: user_payment_info_user_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_payment_info_user_payment_id_seq OWNED BY public.user_payment_info.user_payment_id;


--
-- TOC entry 212 (class 1259 OID 26674)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying(10),
    last_name character varying(10),
    mail character varying(50),
    password character varying(30) NOT NULL,
    role_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 26673)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3251 (class 2604 OID 26787)
-- Name: address address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address ALTER COLUMN address_id SET DEFAULT nextval('public.address_address_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 26842)
-- Name: all_leased_cars leased_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_leased_cars ALTER COLUMN leased_id SET DEFAULT nextval('public.all_leased_cars_leased_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 26710)
-- Name: brands brand_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands ALTER COLUMN brand_id SET DEFAULT nextval('public.brands_brand_id_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 26729)
-- Name: cars car_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars ALTER COLUMN car_id SET DEFAULT nextval('public.cars_car_id_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 26691)
-- Name: cities city_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN city_id SET DEFAULT nextval('public.cities_city_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 26698)
-- Name: dealers dealer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers ALTER COLUMN dealer_id SET DEFAULT nextval('public.dealers_dealer_id_seq'::regclass);


--
-- TOC entry 3253 (class 2604 OID 26811)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 26717)
-- Name: models model_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models ALTER COLUMN model_id SET DEFAULT nextval('public.models_model_id_seq'::regclass);


--
-- TOC entry 3249 (class 2604 OID 26753)
-- Name: on_rent rent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_rent ALTER COLUMN rent_id SET DEFAULT nextval('public.on_rent_rent_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 26823)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 26775)
-- Name: phone_numbers number_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN number_id SET DEFAULT nextval('public.phone_numbers_number_id_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 26670)
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- TOC entry 3255 (class 2604 OID 26835)
-- Name: totals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.totals ALTER COLUMN id SET DEFAULT nextval('public.totals_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 26799)
-- Name: user_payment_info user_payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_payment_info ALTER COLUMN user_payment_id SET DEFAULT nextval('public.user_payment_info_user_payment_id_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 26677)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3466 (class 0 OID 26784)
-- Dependencies: 228
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3476 (class 0 OID 26839)
-- Dependencies: 238
-- Data for Name: all_leased_cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.all_leased_cars (leased_id, rent_id) VALUES (1, 2);


--
-- TOC entry 3456 (class 0 OID 26707)
-- Dependencies: 218
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.brands (brand_id, brand_name) VALUES (1, 'Mercedes');
INSERT INTO public.brands (brand_id, brand_name) VALUES (2, 'BMW');
INSERT INTO public.brands (brand_id, brand_name) VALUES (3, 'Audi');
INSERT INTO public.brands (brand_id, brand_name) VALUES (4, 'Mitsubishi');
INSERT INTO public.brands (brand_id, brand_name) VALUES (5, 'Volkswagen');
INSERT INTO public.brands (brand_id, brand_name) VALUES (6, 'Peugeot');


--
-- TOC entry 3460 (class 0 OID 26726)
-- Dependencies: 222
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (1, '100', 'diesel', 'sedan', 'manuel', '5', 'https://images.unsplash.com/photo-1571224237891-bfb45fcf0920?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1339&q=80', 1, 1, 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (2, '500', 'diesel', 'SUV', 'Manuel', '5', 'https://images.unsplash.com/photo-1492967396498-f79507b65e89?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', 1, 2, 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (3, '600', 'diesel', 'SUV', 'Manuel', '5', 'https://images.unsplash.com/photo-1518613158449-d23f7e69dfb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1240&q=80', 2, 3, 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (4, '200', 'diesel', 'Sedan', 'Automatic', '5', 'https://images.unsplash.com/photo-1523983388277-336a66bf9bcd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', 2, 4, 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (5, '50', 'diesel', 'Hatchback', 'Automatic', '5', 'https://images.unsplash.com/photo-1639058975078-62acadc4680a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', 3, 5, 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (6, '500', 'diesel', 'SUV', 'Automatic', '5', 'https://images.unsplash.com/photo-1626075195920-5df44dc27674?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80', 3, 6, 2, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (7, '150', 'Gasoline', 'SUV', 'Manuel', '5', 'https://images.unsplash.com/photo-1596429924638-d1f8a252df7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=867&q=80', 4, 7, 2, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (8, '50', 'diesel', 'Hatchback', 'Automatic', '5', 'https://images.unsplash.com/photo-1590137303959-f500008a2930?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80', 5, 8, 2, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.cars (car_id, price, fuel, type, gear, seat, image_url, brand_id, model_id, dealer_id, created_at, updated_at, deleted_at) VALUES (9, '200', 'diesel', 'SUV', 'Automatic', '5', 'https://images.unsplash.com/photo-1566421740474-8456c6840c71?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', 6, 9, 2, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');


--
-- TOC entry 3452 (class 0 OID 26688)
-- Dependencies: 214
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cities (city_id, name) VALUES (1, 'Adana');
INSERT INTO public.cities (city_id, name) VALUES (2, 'Adıyaman');
INSERT INTO public.cities (city_id, name) VALUES (3, 'Afyonkarahisar');
INSERT INTO public.cities (city_id, name) VALUES (4, 'Ağrı');
INSERT INTO public.cities (city_id, name) VALUES (5, 'Amasya');
INSERT INTO public.cities (city_id, name) VALUES (6, 'Ankara');
INSERT INTO public.cities (city_id, name) VALUES (7, 'Antalya');
INSERT INTO public.cities (city_id, name) VALUES (8, 'Artvin');
INSERT INTO public.cities (city_id, name) VALUES (9, 'Aydın');
INSERT INTO public.cities (city_id, name) VALUES (10, 'Balıkesir');
INSERT INTO public.cities (city_id, name) VALUES (11, 'Bilecik');
INSERT INTO public.cities (city_id, name) VALUES (12, 'Bingöl');
INSERT INTO public.cities (city_id, name) VALUES (13, 'Bitlis');
INSERT INTO public.cities (city_id, name) VALUES (14, 'Bolu');
INSERT INTO public.cities (city_id, name) VALUES (15, 'Burdur');
INSERT INTO public.cities (city_id, name) VALUES (16, 'Bursa');
INSERT INTO public.cities (city_id, name) VALUES (17, 'Çanakkale');
INSERT INTO public.cities (city_id, name) VALUES (18, 'Çankırı');
INSERT INTO public.cities (city_id, name) VALUES (19, 'Çorum');
INSERT INTO public.cities (city_id, name) VALUES (20, 'Denizli');
INSERT INTO public.cities (city_id, name) VALUES (21, 'Diyarbakır');
INSERT INTO public.cities (city_id, name) VALUES (22, 'Edirne');
INSERT INTO public.cities (city_id, name) VALUES (23, 'Elazığ');
INSERT INTO public.cities (city_id, name) VALUES (24, 'Erzincan');
INSERT INTO public.cities (city_id, name) VALUES (25, 'Erzurum');
INSERT INTO public.cities (city_id, name) VALUES (26, 'Eskişehir');
INSERT INTO public.cities (city_id, name) VALUES (27, 'Gaziantep');
INSERT INTO public.cities (city_id, name) VALUES (28, 'Giresun');
INSERT INTO public.cities (city_id, name) VALUES (29, 'Gümüşhane');
INSERT INTO public.cities (city_id, name) VALUES (30, 'Hakkari');
INSERT INTO public.cities (city_id, name) VALUES (31, 'Hatay');
INSERT INTO public.cities (city_id, name) VALUES (32, 'Isparta');
INSERT INTO public.cities (city_id, name) VALUES (33, 'Mersin');
INSERT INTO public.cities (city_id, name) VALUES (34, 'İstanbul');
INSERT INTO public.cities (city_id, name) VALUES (35, 'İzmir');
INSERT INTO public.cities (city_id, name) VALUES (36, 'Kars');
INSERT INTO public.cities (city_id, name) VALUES (37, 'Kastamonu');
INSERT INTO public.cities (city_id, name) VALUES (38, 'Kayseri');
INSERT INTO public.cities (city_id, name) VALUES (39, 'Kırklareli');
INSERT INTO public.cities (city_id, name) VALUES (40, 'Kırşehir');
INSERT INTO public.cities (city_id, name) VALUES (41, 'Kocaeli');
INSERT INTO public.cities (city_id, name) VALUES (42, 'Konya');
INSERT INTO public.cities (city_id, name) VALUES (43, 'Kütahya');
INSERT INTO public.cities (city_id, name) VALUES (44, 'Malatya');
INSERT INTO public.cities (city_id, name) VALUES (45, 'Manisa');
INSERT INTO public.cities (city_id, name) VALUES (46, 'Kahramanmaraş');
INSERT INTO public.cities (city_id, name) VALUES (47, 'Mardin');
INSERT INTO public.cities (city_id, name) VALUES (48, 'Muğla');
INSERT INTO public.cities (city_id, name) VALUES (49, 'Muş');
INSERT INTO public.cities (city_id, name) VALUES (50, 'Nevşehir');
INSERT INTO public.cities (city_id, name) VALUES (51, 'Niğde');
INSERT INTO public.cities (city_id, name) VALUES (52, 'Ordu');
INSERT INTO public.cities (city_id, name) VALUES (53, 'Rize');
INSERT INTO public.cities (city_id, name) VALUES (54, 'Sakarya');
INSERT INTO public.cities (city_id, name) VALUES (55, 'Samsun');
INSERT INTO public.cities (city_id, name) VALUES (56, 'Siirt');
INSERT INTO public.cities (city_id, name) VALUES (57, 'Sinop');
INSERT INTO public.cities (city_id, name) VALUES (58, 'Sivas');
INSERT INTO public.cities (city_id, name) VALUES (59, 'Tekirdağ');
INSERT INTO public.cities (city_id, name) VALUES (60, 'Tokat');
INSERT INTO public.cities (city_id, name) VALUES (61, 'Trabzon');
INSERT INTO public.cities (city_id, name) VALUES (62, 'Tunceli');
INSERT INTO public.cities (city_id, name) VALUES (63, 'Şanlıurfa');
INSERT INTO public.cities (city_id, name) VALUES (64, 'Uşak');
INSERT INTO public.cities (city_id, name) VALUES (65, 'Van');
INSERT INTO public.cities (city_id, name) VALUES (66, 'Yozgat');
INSERT INTO public.cities (city_id, name) VALUES (67, 'Zonguldak');
INSERT INTO public.cities (city_id, name) VALUES (68, 'Aksaray');
INSERT INTO public.cities (city_id, name) VALUES (69, 'Bayburt');
INSERT INTO public.cities (city_id, name) VALUES (70, 'Karaman');
INSERT INTO public.cities (city_id, name) VALUES (71, 'Kırıkkale');
INSERT INTO public.cities (city_id, name) VALUES (72, 'Batman');
INSERT INTO public.cities (city_id, name) VALUES (73, 'Şırnak');
INSERT INTO public.cities (city_id, name) VALUES (74, 'Bartın');
INSERT INTO public.cities (city_id, name) VALUES (75, 'Ardahan');
INSERT INTO public.cities (city_id, name) VALUES (76, 'Iğdır');
INSERT INTO public.cities (city_id, name) VALUES (77, 'Yalova');
INSERT INTO public.cities (city_id, name) VALUES (78, 'Karabük');
INSERT INTO public.cities (city_id, name) VALUES (79, 'Kilis');
INSERT INTO public.cities (city_id, name) VALUES (80, 'Osmaniye');
INSERT INTO public.cities (city_id, name) VALUES (81, 'Düzce');


--
-- TOC entry 3454 (class 0 OID 26695)
-- Dependencies: 216
-- Data for Name: dealers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dealers (dealer_id, dealer_name, city_id) VALUES (1, 'A', 61);
INSERT INTO public.dealers (dealer_id, dealer_name, city_id) VALUES (2, 'B', 61);
INSERT INTO public.dealers (dealer_id, dealer_name, city_id) VALUES (3, 'C', 61);
INSERT INTO public.dealers (dealer_id, dealer_name, city_id) VALUES (4, 'E', 26);


--
-- TOC entry 3470 (class 0 OID 26808)
-- Dependencies: 232
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employees (employee_id, first_name, last_name, email, phone_number, hire_date, salary, dealer_id) VALUES (1, 'Beyza', 'Erkan', 'beyzaerkan@icloud.com', '12345678912', '2021-12-10 18:23:36', 7000.00, 1);
INSERT INTO public.employees (employee_id, first_name, last_name, email, phone_number, hire_date, salary, dealer_id) VALUES (2, 'Burak', 'Erkan', 'ze@icloud.com', '12345678912', '2021-12-10 18:23:36', 7000.00, 1);


--
-- TOC entry 3458 (class 0 OID 26714)
-- Dependencies: 220
-- Data for Name: models; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.models (model_id, model_name, brand_id) VALUES (1, 'A200', 1);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (2, 'G63', 1);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (3, 'X3', 2);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (4, '520i', 2);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (5, 'A3', 3);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (6, 'Q7', 3);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (7, 'ASX', 4);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (8, 'Polo', 5);
INSERT INTO public.models (model_id, model_name, brand_id) VALUES (9, '5008', 6);


--
-- TOC entry 3462 (class 0 OID 26750)
-- Dependencies: 224
-- Data for Name: on_rent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.on_rent (rent_id, day, reception_date, delivery_date, user_id, car_id, dealer_id, rent_payment) VALUES (1, 5, '2021-12-10 18:23:36', '2021-12-15 18:23:36', 2, 1, 1, 500);
INSERT INTO public.on_rent (rent_id, day, reception_date, delivery_date, user_id, car_id, dealer_id, rent_payment) VALUES (2, 5, '2021-12-10 18:23:36', '2021-12-12 15:23:36', 2, 2, 1, 25000);


--
-- TOC entry 3472 (class 0 OID 26820)
-- Dependencies: 234
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payments (payment_id, payment, rent_id, payment_date) VALUES (1, 25000, 2, '2021-12-12 15:49:08.139688');


--
-- TOC entry 3464 (class 0 OID 26772)
-- Dependencies: 226
-- Data for Name: phone_numbers; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3448 (class 0 OID 26667)
-- Dependencies: 210
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (role_id, role) VALUES (1, 'admin');
INSERT INTO public.roles (role_id, role) VALUES (2, 'customer');


--
-- TOC entry 3474 (class 0 OID 26832)
-- Dependencies: 236
-- Data for Name: totals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.totals (id, total_payment, total_employee_salary, total_leased_cars) VALUES (1, 25000, 14000, 2);


--
-- TOC entry 3468 (class 0 OID 26796)
-- Dependencies: 230
-- Data for Name: user_payment_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3450 (class 0 OID 26674)
-- Dependencies: 212
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (user_id, first_name, last_name, mail, password, role_id, created_at, updated_at, deleted_at) VALUES (1, 'Beyza', 'Erkan', 'beyzaerkan@icloud.com', '123456', 1, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');
INSERT INTO public.users (user_id, first_name, last_name, mail, password, role_id, created_at, updated_at, deleted_at) VALUES (2, 'Zeynep', 'Kurt', 'zeynepkurt@icloud.com', '789456', 2, '2021-12-10 18:23:36', '2021-12-10 18:23:36', '2021-12-10 18:23:36');


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 227
-- Name: address_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.address_address_id_seq', 1, false);


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 237
-- Name: all_leased_cars_leased_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.all_leased_cars_leased_id_seq', 1, true);


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 217
-- Name: brands_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brands_brand_id_seq', 1, false);


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 221
-- Name: cars_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cars_car_id_seq', 1, false);


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 213
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_city_id_seq', 1, false);


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 215
-- Name: dealers_dealer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealers_dealer_id_seq', 1, false);


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 231
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 219
-- Name: models_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.models_model_id_seq', 1, false);


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 223
-- Name: on_rent_rent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.on_rent_rent_id_seq', 1, false);


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 233
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, true);


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 225
-- Name: phone_numbers_number_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phone_numbers_number_id_seq', 1, false);


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 209
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 235
-- Name: totals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.totals_id_seq', 1, false);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 229
-- Name: user_payment_info_user_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_payment_info_user_payment_id_seq', 1, false);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 3278 (class 2606 OID 26789)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- TOC entry 3288 (class 2606 OID 26844)
-- Name: all_leased_cars all_leased_cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_leased_cars
    ADD CONSTRAINT all_leased_cars_pkey PRIMARY KEY (leased_id);


--
-- TOC entry 3268 (class 2606 OID 26712)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (brand_id);


--
-- TOC entry 3272 (class 2606 OID 26733)
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);


--
-- TOC entry 3264 (class 2606 OID 26693)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 3266 (class 2606 OID 26700)
-- Name: dealers dealers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_pkey PRIMARY KEY (dealer_id);


--
-- TOC entry 3282 (class 2606 OID 26813)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3270 (class 2606 OID 26719)
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (model_id);


--
-- TOC entry 3274 (class 2606 OID 26755)
-- Name: on_rent on_rent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_rent
    ADD CONSTRAINT on_rent_pkey PRIMARY KEY (rent_id);


--
-- TOC entry 3284 (class 2606 OID 26825)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 3276 (class 2606 OID 26777)
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (number_id);


--
-- TOC entry 3258 (class 2606 OID 26672)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 3286 (class 2606 OID 26837)
-- Name: totals totals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.totals
    ADD CONSTRAINT totals_pkey PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 26801)
-- Name: user_payment_info user_payment_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_payment_info
    ADD CONSTRAINT user_payment_info_pkey PRIMARY KEY (user_payment_id);


--
-- TOC entry 3260 (class 2606 OID 26681)
-- Name: users users_mail_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_mail_key UNIQUE (mail);


--
-- TOC entry 3262 (class 2606 OID 26679)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3304 (class 2620 OID 26851)
-- Name: on_rent addeasedcarstrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER addeasedcarstrig AFTER INSERT ON public.on_rent FOR EACH ROW EXECUTE FUNCTION public.addleasedcarstotal();


--
-- TOC entry 3306 (class 2620 OID 26853)
-- Name: payments lastpaymenttrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER lastpaymenttrig AFTER INSERT ON public.payments FOR EACH ROW EXECUTE FUNCTION public.totalpayments();


--
-- TOC entry 3307 (class 2620 OID 26860)
-- Name: all_leased_cars paymenttrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER paymenttrig AFTER INSERT ON public.all_leased_cars FOR EACH ROW EXECUTE FUNCTION public.all_leased_insert_trigger();


--
-- TOC entry 3305 (class 2620 OID 26855)
-- Name: employees salarytrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER salarytrig AFTER INSERT ON public.employees FOR EACH ROW EXECUTE FUNCTION public.totalsalaries();


--
-- TOC entry 3299 (class 2606 OID 26790)
-- Name: address address_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3303 (class 2606 OID 26845)
-- Name: all_leased_cars all_leased_cars_rent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_leased_cars
    ADD CONSTRAINT all_leased_cars_rent_id_fkey FOREIGN KEY (rent_id) REFERENCES public.on_rent(rent_id);


--
-- TOC entry 3292 (class 2606 OID 26734)
-- Name: cars cars_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(brand_id);


--
-- TOC entry 3294 (class 2606 OID 26744)
-- Name: cars cars_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(dealer_id);


--
-- TOC entry 3293 (class 2606 OID 26739)
-- Name: cars cars_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.models(model_id);


--
-- TOC entry 3290 (class 2606 OID 26701)
-- Name: dealers dealers_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id);


--
-- TOC entry 3301 (class 2606 OID 26814)
-- Name: employees employees_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(dealer_id);


--
-- TOC entry 3291 (class 2606 OID 26720)
-- Name: models models_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(brand_id);


--
-- TOC entry 3296 (class 2606 OID 26761)
-- Name: on_rent on_rent_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_rent
    ADD CONSTRAINT on_rent_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.cars(car_id);


--
-- TOC entry 3297 (class 2606 OID 26766)
-- Name: on_rent on_rent_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_rent
    ADD CONSTRAINT on_rent_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(dealer_id);


--
-- TOC entry 3295 (class 2606 OID 26756)
-- Name: on_rent on_rent_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_rent
    ADD CONSTRAINT on_rent_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3302 (class 2606 OID 26826)
-- Name: payments payments_rent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_rent_id_fkey FOREIGN KEY (rent_id) REFERENCES public.on_rent(rent_id);


--
-- TOC entry 3298 (class 2606 OID 26778)
-- Name: phone_numbers phone_numbers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3300 (class 2606 OID 26802)
-- Name: user_payment_info user_payment_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_payment_info
    ADD CONSTRAINT user_payment_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3289 (class 2606 OID 26682)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


-- Completed on 2021-12-12 23:32:26

--
-- PostgreSQL database dump complete
--

