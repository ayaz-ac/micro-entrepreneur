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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: configured_off_days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configured_off_days (
    id bigint NOT NULL,
    day_of_week integer,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: configured_off_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configured_off_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configured_off_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configured_off_days_id_seq OWNED BY public.configured_off_days.id;


--
-- Name: estimated_incomes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estimated_incomes (
    id bigint NOT NULL,
    month integer,
    year integer,
    amount numeric,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: estimated_incomes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estimated_incomes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estimated_incomes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estimated_incomes_id_seq OWNED BY public.estimated_incomes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: work_days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_days (
    id bigint NOT NULL,
    date timestamp(6) without time zone,
    status integer,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: work_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_days_id_seq OWNED BY public.work_days.id;


--
-- Name: configured_off_days id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configured_off_days ALTER COLUMN id SET DEFAULT nextval('public.configured_off_days_id_seq'::regclass);


--
-- Name: estimated_incomes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estimated_incomes ALTER COLUMN id SET DEFAULT nextval('public.estimated_incomes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: work_days id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_days ALTER COLUMN id SET DEFAULT nextval('public.work_days_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: configured_off_days configured_off_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configured_off_days
    ADD CONSTRAINT configured_off_days_pkey PRIMARY KEY (id);


--
-- Name: estimated_incomes estimated_incomes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estimated_incomes
    ADD CONSTRAINT estimated_incomes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: work_days work_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT work_days_pkey PRIMARY KEY (id);


--
-- Name: index_configured_off_days_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_configured_off_days_on_user_id ON public.configured_off_days USING btree (user_id);


--
-- Name: index_estimated_incomes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_estimated_incomes_on_user_id ON public.estimated_incomes USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_work_days_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_work_days_on_user_id ON public.work_days USING btree (user_id);


--
-- Name: work_days fk_rails_1cd2cc3e72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT fk_rails_1cd2cc3e72 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: estimated_incomes fk_rails_42cc34a49b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estimated_incomes
    ADD CONSTRAINT fk_rails_42cc34a49b FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: configured_off_days fk_rails_76c90efe6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configured_off_days
    ADD CONSTRAINT fk_rails_76c90efe6c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240228205524'),
('20240228205444'),
('20240228205347'),
('20231209120942');

