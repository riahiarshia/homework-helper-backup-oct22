--
-- PostgreSQL database dump
--

\restrict He0FjsERK1qqx7kKdeUV2Nek6cGqe6CWCk3k3cUA7HV5Us0QsUevNJ4rjMXyoLd

-- Dumped from database version 15.14
-- Dumped by pg_dump version 16.10 (Homebrew)

-- Started on 2025-10-18 15:21:18 MST

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

ALTER TABLE ONLY public.subscription_history DROP CONSTRAINT subscription_history_user_id_fkey;
ALTER TABLE ONLY public.promo_code_usage DROP CONSTRAINT promo_code_usage_user_id_fkey;
ALTER TABLE ONLY public.promo_code_usage DROP CONSTRAINT promo_code_usage_promo_code_id_fkey;
ALTER TABLE ONLY public.password_reset_tokens DROP CONSTRAINT password_reset_tokens_user_id_fkey;
ALTER TABLE ONLY public.homework_submissions DROP CONSTRAINT homework_submissions_user_id_fkey;
DROP TRIGGER update_users_updated_at ON public.users;
DROP TRIGGER trigger_update_user_entitlements_timestamp ON public.user_entitlements;
DROP TRIGGER trigger_update_trial_history_timestamp ON public.trial_usage_history;
DROP TRIGGER set_trial_on_insert ON public.users;
CREATE OR REPLACE VIEW public.promo_code_stats AS
SELECT
    NULL::character varying(100) AS code,
    NULL::integer AS duration_days,
    NULL::integer AS uses_total,
    NULL::integer AS uses_remaining,
    NULL::boolean AS active,
    NULL::bigint AS actual_uses,
    NULL::timestamp without time zone AS created_at;
DROP INDEX public.user_entitlements_user_idx;
DROP INDEX public.user_entitlements_txid_hash_idx;
DROP INDEX public.user_entitlements_status_idx;
DROP INDEX public.idx_users_user_id;
DROP INDEX public.idx_users_subscription_status;
DROP INDEX public.idx_users_subscription_end_date;
DROP INDEX public.idx_users_stripe_customer_id;
DROP INDEX public.idx_users_password_hash;
DROP INDEX public.idx_users_email;
DROP INDEX public.idx_users_apple_user_id;
DROP INDEX public.idx_user_devices_user_id;
DROP INDEX public.idx_user_devices_trusted;
DROP INDEX public.idx_user_devices_device_id;
DROP INDEX public.idx_user_api_usage_user_id;
DROP INDEX public.idx_user_api_usage_user_date;
DROP INDEX public.idx_user_api_usage_model;
DROP INDEX public.idx_user_api_usage_endpoint;
DROP INDEX public.idx_user_api_usage_device_id;
DROP INDEX public.idx_user_api_usage_created_at;
DROP INDEX public.idx_trial_history_user_id;
DROP INDEX public.idx_trial_history_original_transaction;
DROP INDEX public.idx_trial_history_created_at;
DROP INDEX public.idx_sub_history_user_id;
DROP INDEX public.idx_sub_history_event_type;
DROP INDEX public.idx_sub_history_created_at;
DROP INDEX public.idx_promo_usage_user_id;
DROP INDEX public.idx_promo_usage_promo_id;
DROP INDEX public.idx_promo_codes_expires_at;
DROP INDEX public.idx_promo_codes_code;
DROP INDEX public.idx_promo_codes_active;
DROP INDEX public.idx_password_reset_tokens_user_id;
DROP INDEX public.idx_password_reset_tokens_used;
DROP INDEX public.idx_password_reset_tokens_token;
DROP INDEX public.idx_password_reset_tokens_expires_at;
DROP INDEX public.idx_homework_submissions_user_id;
DROP INDEX public.idx_homework_submissions_submitted_at;
DROP INDEX public.idx_homework_submissions_status;
DROP INDEX public.idx_homework_submissions_problem_id;
DROP INDEX public.idx_fraud_flags_user_id;
DROP INDEX public.idx_fraud_flags_severity;
DROP INDEX public.idx_fraud_flags_resolved;
DROP INDEX public.idx_fraud_flags_device_id;
DROP INDEX public.idx_device_logins_user_id;
DROP INDEX public.idx_device_logins_login_time;
DROP INDEX public.idx_device_logins_device_id;
DROP INDEX public.idx_apple_product_id;
DROP INDEX public.idx_apple_original_transaction_id;
DROP INDEX public.idx_admin_username;
DROP INDEX public.idx_admin_email;
DROP INDEX public.idx_admin_audit_log_created_at;
DROP INDEX public.idx_admin_audit_log_admin_user_id;
DROP INDEX public.idx_admin_audit_log_action;
DROP INDEX public.ent_ledger_txid_hash_idx;
DROP INDEX public.ent_ledger_status_idx;
DROP INDEX public.ent_ledger_last_seen_idx;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_user_id_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.user_entitlements DROP CONSTRAINT user_entitlements_pkey;
ALTER TABLE ONLY public.user_devices DROP CONSTRAINT user_devices_pkey;
ALTER TABLE ONLY public.user_api_usage DROP CONSTRAINT user_api_usage_pkey;
ALTER TABLE ONLY public.trial_usage_history DROP CONSTRAINT trial_usage_history_pkey;
ALTER TABLE ONLY public.trial_usage_history DROP CONSTRAINT trial_usage_history_original_transaction_id_key;
ALTER TABLE ONLY public.subscription_history DROP CONSTRAINT subscription_history_pkey;
ALTER TABLE ONLY public.promo_codes DROP CONSTRAINT promo_codes_pkey;
ALTER TABLE ONLY public.promo_codes DROP CONSTRAINT promo_codes_code_key;
ALTER TABLE ONLY public.promo_code_usage DROP CONSTRAINT promo_code_usage_promo_code_id_user_id_key;
ALTER TABLE ONLY public.promo_code_usage DROP CONSTRAINT promo_code_usage_pkey;
ALTER TABLE ONLY public.password_reset_tokens DROP CONSTRAINT password_reset_tokens_token_key;
ALTER TABLE ONLY public.password_reset_tokens DROP CONSTRAINT password_reset_tokens_pkey;
ALTER TABLE ONLY public.homework_submissions DROP CONSTRAINT homework_submissions_pkey;
ALTER TABLE ONLY public.fraud_flags DROP CONSTRAINT fraud_flags_pkey;
ALTER TABLE ONLY public.entitlements_ledger DROP CONSTRAINT entitlements_ledger_pkey;
ALTER TABLE ONLY public.device_logins DROP CONSTRAINT device_logins_pkey;
ALTER TABLE ONLY public.admin_users DROP CONSTRAINT admin_users_username_key;
ALTER TABLE ONLY public.admin_users DROP CONSTRAINT admin_users_pkey;
ALTER TABLE ONLY public.admin_users DROP CONSTRAINT admin_users_email_key;
ALTER TABLE ONLY public.admin_audit_log DROP CONSTRAINT admin_audit_log_pkey;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_api_usage ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.trial_usage_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.subscription_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.promo_codes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.promo_code_usage ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.password_reset_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.homework_submissions ALTER COLUMN submission_id DROP DEFAULT;
ALTER TABLE public.fraud_flags ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.device_logins ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.admin_users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.admin_audit_log ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.users_id_seq;
DROP VIEW public.user_usage_summary;
DROP TABLE public.user_entitlements;
DROP TABLE public.user_devices;
DROP SEQUENCE public.user_api_usage_id_seq;
DROP SEQUENCE public.trial_usage_history_id_seq;
DROP TABLE public.trial_usage_history;
DROP SEQUENCE public.subscription_history_id_seq;
DROP TABLE public.subscription_history;
DROP SEQUENCE public.promo_codes_id_seq;
DROP TABLE public.promo_codes;
DROP SEQUENCE public.promo_code_usage_id_seq;
DROP TABLE public.promo_code_usage;
DROP VIEW public.promo_code_stats;
DROP SEQUENCE public.password_reset_tokens_id_seq;
DROP TABLE public.password_reset_tokens;
DROP VIEW public.monthly_usage_summary;
DROP SEQUENCE public.homework_submissions_submission_id_seq;
DROP TABLE public.homework_submissions;
DROP SEQUENCE public.fraud_flags_id_seq;
DROP TABLE public.fraud_flags;
DROP VIEW public.expired_users;
DROP TABLE public.entitlements_ledger;
DROP VIEW public.endpoint_usage_summary;
DROP VIEW public.device_usage_summary;
DROP SEQUENCE public.device_logins_id_seq;
DROP TABLE public.device_logins;
DROP VIEW public.daily_usage_summary;
DROP TABLE public.user_api_usage;
DROP SEQUENCE public.admin_users_id_seq;
DROP TABLE public.admin_users;
DROP SEQUENCE public.admin_audit_log_id_seq;
DROP TABLE public.admin_audit_log;
DROP VIEW public.active_users;
DROP TABLE public.users;
DROP FUNCTION public.update_user_entitlements_updated_at();
DROP FUNCTION public.update_updated_at_column();
DROP FUNCTION public.update_trial_history_updated_at();
DROP FUNCTION public.update_monthly_usage_summary(p_user_id uuid, p_tokens bigint, p_cost_usd numeric, p_api_calls integer);
DROP FUNCTION public.set_trial_dates();
DROP FUNCTION public.reset_monthly_usage_on_renewal(p_user_id uuid);
-- *not* dropping schema, since initdb creates it
--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 255 (class 1255 OID 25120)
-- Name: reset_monthly_usage_on_renewal(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reset_monthly_usage_on_renewal(p_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO monthly_usage_summary (user_id, year, month, subscription_renewals_count)
    VALUES (
        p_user_id,
        EXTRACT(YEAR FROM CURRENT_DATE),
        EXTRACT(MONTH FROM CURRENT_DATE),
        1
    )
    ON CONFLICT (user_id, year, month)
    DO UPDATE SET
        subscription_renewals_count = monthly_usage_summary.subscription_renewals_count + 1,
        updated_at = CURRENT_TIMESTAMP;
    
    RAISE NOTICE 'Monthly usage tracking reset for user % in %-%', 
        p_user_id, 
        EXTRACT(YEAR FROM CURRENT_DATE), 
        EXTRACT(MONTH FROM CURRENT_DATE);
END;
$$;


--
-- TOC entry 251 (class 1255 OID 24916)
-- Name: set_trial_dates(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_trial_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.subscription_status = 'trial' AND NEW.subscription_end_date IS NULL THEN
        NEW.subscription_start_date = NOW();
        NEW.subscription_end_date = NOW() + INTERVAL '14 days';
        NEW.trial_started_at = NOW();
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 252 (class 1255 OID 25119)
-- Name: update_monthly_usage_summary(uuid, bigint, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_monthly_usage_summary(p_user_id uuid, p_tokens bigint, p_cost_usd numeric, p_api_calls integer DEFAULT 1) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO monthly_usage_summary (user_id, year, month, total_tokens, total_cost_usd, api_calls_count)
    VALUES (
        p_user_id,
        EXTRACT(YEAR FROM CURRENT_DATE),
        EXTRACT(MONTH FROM CURRENT_DATE),
        p_tokens,
        p_cost_usd,
        p_api_calls
    )
    ON CONFLICT (user_id, year, month)
    DO UPDATE SET
        total_tokens = monthly_usage_summary.total_tokens + p_tokens,
        total_cost_usd = monthly_usage_summary.total_cost_usd + p_cost_usd,
        api_calls_count = monthly_usage_summary.api_calls_count + p_api_calls,
        updated_at = CURRENT_TIMESTAMP;
END;
$$;


--
-- TOC entry 256 (class 1255 OID 25141)
-- Name: update_trial_history_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_trial_history_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- TOC entry 250 (class 1255 OID 24914)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- TOC entry 257 (class 1255 OID 25158)
-- Name: update_user_entitlements_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user_entitlements_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24817)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(255),
    auth_provider character varying(50),
    subscription_status character varying(50) DEFAULT 'trial'::character varying NOT NULL,
    subscription_start_date timestamp without time zone,
    subscription_end_date timestamp without time zone,
    trial_started_at timestamp without time zone DEFAULT now(),
    promo_code_used character varying(100),
    promo_activated_at timestamp without time zone,
    stripe_customer_id character varying(255),
    stripe_subscription_id character varying(255),
    is_active boolean DEFAULT true,
    is_banned boolean DEFAULT false,
    banned_reason text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    last_active_at timestamp without time zone,
    password_hash character varying(255),
    apple_user_id character varying(255),
    apple_original_transaction_id character varying(255),
    apple_product_id character varying(255),
    apple_environment character varying(50) DEFAULT 'Production'::character varying,
    grade character varying(50) DEFAULT '4th grade'::character varying
);


--
-- TOC entry 224 (class 1259 OID 24918)
-- Name: active_users; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.active_users AS
 SELECT users.user_id,
    users.email,
    users.username,
    users.subscription_status,
    users.subscription_end_date,
    EXTRACT(day FROM ((users.subscription_end_date)::timestamp with time zone - now())) AS days_remaining
   FROM public.users
  WHERE ((users.subscription_end_date > now()) AND (users.is_active = true) AND (users.is_banned = false));


--
-- TOC entry 246 (class 1259 OID 25177)
-- Name: admin_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_audit_log (
    id integer NOT NULL,
    admin_user_id character varying(255) NOT NULL,
    admin_username character varying(255),
    admin_email character varying(255),
    action character varying(255) NOT NULL,
    target_type character varying(100),
    target_id character varying(255),
    target_email character varying(255),
    target_username character varying(255),
    details text,
    ip_address inet,
    user_agent text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 245 (class 1259 OID 25176)
-- Name: admin_audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4371 (class 0 OID 0)
-- Dependencies: 245
-- Name: admin_audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_audit_log_id_seq OWNED BY public.admin_audit_log.id;


--
-- TOC entry 223 (class 1259 OID 24897)
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'admin'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    last_login timestamp without time zone
);


--
-- TOC entry 222 (class 1259 OID 24896)
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4372 (class 0 OID 0)
-- Dependencies: 222
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- TOC entry 235 (class 1259 OID 25072)
-- Name: user_api_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_api_usage (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    endpoint character varying(100) NOT NULL,
    model character varying(50) NOT NULL,
    prompt_tokens integer DEFAULT 0 NOT NULL,
    completion_tokens integer DEFAULT 0 NOT NULL,
    total_tokens integer DEFAULT 0 NOT NULL,
    cost_usd numeric(10,6) DEFAULT 0.000000 NOT NULL,
    problem_id character varying(255),
    session_id character varying(255),
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    device_id character varying(255)
);


--
-- TOC entry 4373 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE user_api_usage; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.user_api_usage IS 'Tracks OpenAI API usage per user for cost management and analytics';


--
-- TOC entry 4374 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.id IS 'Primary key';


--
-- TOC entry 4375 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.user_id IS 'Foreign key to users table';


--
-- TOC entry 4376 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.endpoint; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.endpoint IS 'API endpoint used (analyze_homework, generate_hint, etc.)';


--
-- TOC entry 4377 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.model; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.model IS 'OpenAI model used (gpt-4o, gpt-4o-mini, etc.)';


--
-- TOC entry 4378 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.prompt_tokens; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.prompt_tokens IS 'Number of tokens in the prompt';


--
-- TOC entry 4379 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.completion_tokens; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.completion_tokens IS 'Number of tokens in the completion';


--
-- TOC entry 4380 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.total_tokens; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.total_tokens IS 'Total tokens used (prompt + completion)';


--
-- TOC entry 4381 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.cost_usd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.cost_usd IS 'Cost in USD based on OpenAI pricing';


--
-- TOC entry 4382 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.problem_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.problem_id IS 'Optional: Reference to homework problem';


--
-- TOC entry 4383 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.session_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.session_id IS 'Optional: Group related API calls';


--
-- TOC entry 4384 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.metadata IS 'Additional metadata (JSON)';


--
-- TOC entry 4385 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN user_api_usage.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_api_usage.created_at IS 'Timestamp of API call';


--
-- TOC entry 239 (class 1259 OID 25104)
-- Name: daily_usage_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.daily_usage_summary AS
 SELECT date(uau.created_at) AS date,
    count(uau.id) AS api_calls,
    count(DISTINCT uau.user_id) AS unique_users,
    sum(uau.prompt_tokens) AS prompt_tokens,
    sum(uau.completion_tokens) AS completion_tokens,
    sum(uau.total_tokens) AS total_tokens,
    sum(uau.cost_usd) AS cost_usd
   FROM public.user_api_usage uau
  WHERE (uau.created_at >= (CURRENT_DATE - '90 days'::interval))
  GROUP BY (date(uau.created_at))
  ORDER BY (date(uau.created_at)) DESC;


--
-- TOC entry 4386 (class 0 OID 0)
-- Dependencies: 239
-- Name: VIEW daily_usage_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.daily_usage_summary IS 'Daily usage statistics (last 90 days)';


--
-- TOC entry 230 (class 1259 OID 24999)
-- Name: device_logins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_logins (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    device_id character varying(255) NOT NULL,
    login_time timestamp without time zone DEFAULT now(),
    ip_address inet,
    user_agent text,
    device_info jsonb,
    created_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 4387 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE device_logins; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.device_logins IS 'Tracks all device login attempts for analytics and fraud detection';


--
-- TOC entry 229 (class 1259 OID 24998)
-- Name: device_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_logins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4388 (class 0 OID 0)
-- Dependencies: 229
-- Name: device_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_logins_id_seq OWNED BY public.device_logins.id;


--
-- TOC entry 240 (class 1259 OID 25109)
-- Name: device_usage_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.device_usage_summary AS
 SELECT uau.device_id,
    count(uau.id) AS total_api_calls,
    count(DISTINCT uau.user_id) AS unique_users,
    sum(uau.prompt_tokens) AS total_prompt_tokens,
    sum(uau.completion_tokens) AS total_completion_tokens,
    sum(uau.total_tokens) AS total_tokens,
    sum(uau.cost_usd) AS total_cost_usd,
    max(uau.created_at) AS last_api_call,
    min(uau.created_at) AS first_api_call
   FROM public.user_api_usage uau
  WHERE (uau.device_id IS NOT NULL)
  GROUP BY uau.device_id
  ORDER BY (sum(uau.cost_usd)) DESC;


--
-- TOC entry 4389 (class 0 OID 0)
-- Dependencies: 240
-- Name: VIEW device_usage_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.device_usage_summary IS 'Aggregated API usage per device';


--
-- TOC entry 238 (class 1259 OID 25100)
-- Name: endpoint_usage_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.endpoint_usage_summary AS
 SELECT uau.endpoint,
    uau.model,
    count(uau.id) AS api_calls,
    sum(uau.prompt_tokens) AS prompt_tokens,
    sum(uau.completion_tokens) AS completion_tokens,
    sum(uau.total_tokens) AS total_tokens,
    sum(uau.cost_usd) AS cost_usd,
    avg(uau.total_tokens) AS avg_tokens_per_call,
    avg(uau.cost_usd) AS avg_cost_per_call
   FROM public.user_api_usage uau
  GROUP BY uau.endpoint, uau.model
  ORDER BY (sum(uau.cost_usd)) DESC;


--
-- TOC entry 4390 (class 0 OID 0)
-- Dependencies: 238
-- Name: VIEW endpoint_usage_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.endpoint_usage_summary IS 'Usage statistics by endpoint and model';


--
-- TOC entry 244 (class 1259 OID 25160)
-- Name: entitlements_ledger; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entitlements_ledger (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id text NOT NULL,
    subscription_group_id text NOT NULL,
    original_transaction_id_hash text NOT NULL,
    ever_trial boolean DEFAULT false NOT NULL,
    status text NOT NULL,
    first_seen_at timestamp with time zone DEFAULT now() NOT NULL,
    last_seen_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT entitlements_ledger_status_check CHECK ((status = ANY (ARRAY['active'::text, 'expired'::text, 'canceled'::text])))
);


--
-- TOC entry 225 (class 1259 OID 24922)
-- Name: expired_users; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.expired_users AS
 SELECT users.user_id,
    users.email,
    users.username,
    users.subscription_status,
    users.subscription_end_date,
    EXTRACT(day FROM (now() - (users.subscription_end_date)::timestamp with time zone)) AS days_expired
   FROM public.users
  WHERE (users.subscription_end_date < now());


--
-- TOC entry 232 (class 1259 OID 25013)
-- Name: fraud_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fraud_flags (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    device_id character varying(255),
    reason text NOT NULL,
    severity character varying(20) DEFAULT 'low'::character varying,
    details jsonb,
    resolved boolean DEFAULT false,
    resolved_at timestamp without time zone,
    resolved_by character varying(255),
    created_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 4391 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE fraud_flags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.fraud_flags IS 'Flags suspicious activity patterns for manual review';


--
-- TOC entry 231 (class 1259 OID 25012)
-- Name: fraud_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fraud_flags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4392 (class 0 OID 0)
-- Dependencies: 231
-- Name: fraud_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fraud_flags_id_seq OWNED BY public.fraud_flags.id;


--
-- TOC entry 248 (class 1259 OID 25190)
-- Name: homework_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.homework_submissions (
    submission_id integer NOT NULL,
    user_id character varying(255),
    problem_id character varying(255) NOT NULL,
    subject character varying(100),
    problem_text text,
    image_filename character varying(255),
    total_steps integer DEFAULT 0,
    completed_steps integer DEFAULT 0,
    skipped_steps integer DEFAULT 0,
    status character varying(50) DEFAULT 'submitted'::character varying,
    time_spent_seconds integer DEFAULT 0,
    hints_used integer DEFAULT 0,
    submitted_at timestamp without time zone DEFAULT now(),
    completed_at timestamp without time zone
);


--
-- TOC entry 247 (class 1259 OID 25189)
-- Name: homework_submissions_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.homework_submissions_submission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4393 (class 0 OID 0)
-- Dependencies: 247
-- Name: homework_submissions_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.homework_submissions_submission_id_seq OWNED BY public.homework_submissions.submission_id;


--
-- TOC entry 237 (class 1259 OID 25095)
-- Name: monthly_usage_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monthly_usage_summary AS
 SELECT u.user_id,
    u.username,
    u.email,
    date_trunc('month'::text, uau.created_at) AS month,
    count(uau.id) AS api_calls,
    sum(uau.prompt_tokens) AS prompt_tokens,
    sum(uau.completion_tokens) AS completion_tokens,
    sum(uau.total_tokens) AS total_tokens,
    sum(uau.cost_usd) AS cost_usd
   FROM (public.users u
     LEFT JOIN public.user_api_usage uau ON (((u.user_id)::text = (uau.user_id)::text)))
  WHERE (uau.created_at >= date_trunc('month'::text, (now() - '1 year'::interval)))
  GROUP BY u.user_id, u.username, u.email, (date_trunc('month'::text, uau.created_at))
  ORDER BY (date_trunc('month'::text, uau.created_at)) DESC, (sum(uau.cost_usd)) DESC NULLS LAST;


--
-- TOC entry 4394 (class 0 OID 0)
-- Dependencies: 237
-- Name: VIEW monthly_usage_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.monthly_usage_summary IS 'Monthly aggregated usage per user (last 12 months)';


--
-- TOC entry 228 (class 1259 OID 24943)
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    used boolean DEFAULT false,
    used_at timestamp without time zone
);


--
-- TOC entry 4395 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE password_reset_tokens; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.password_reset_tokens IS 'Stores tokens for password reset functionality';


--
-- TOC entry 4396 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.id IS 'Primary key';


--
-- TOC entry 4397 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.user_id IS 'Foreign key to users table';


--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.token IS 'Secure random token for password reset';


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.expires_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.expires_at IS 'Token expiration time (1 hour from creation)';


--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.used; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.used IS 'Whether the token has been used';


--
-- TOC entry 4401 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN password_reset_tokens.used_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.password_reset_tokens.used_at IS 'When the token was used';


--
-- TOC entry 227 (class 1259 OID 24942)
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.password_reset_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4402 (class 0 OID 0)
-- Dependencies: 227
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


--
-- TOC entry 226 (class 1259 OID 24926)
-- Name: promo_code_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.promo_code_stats AS
SELECT
    NULL::character varying(100) AS code,
    NULL::integer AS duration_days,
    NULL::integer AS uses_total,
    NULL::integer AS uses_remaining,
    NULL::boolean AS active,
    NULL::bigint AS actual_uses,
    NULL::timestamp without time zone AS created_at;


--
-- TOC entry 219 (class 1259 OID 24857)
-- Name: promo_code_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promo_code_usage (
    id integer NOT NULL,
    promo_code_id integer,
    user_id character varying(255),
    activated_at timestamp without time zone DEFAULT now(),
    ip_address character varying(50)
);


--
-- TOC entry 218 (class 1259 OID 24856)
-- Name: promo_code_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promo_code_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4403 (class 0 OID 0)
-- Dependencies: 218
-- Name: promo_code_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promo_code_usage_id_seq OWNED BY public.promo_code_usage.id;


--
-- TOC entry 217 (class 1259 OID 24839)
-- Name: promo_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promo_codes (
    id integer NOT NULL,
    code character varying(100) NOT NULL,
    duration_days integer NOT NULL,
    uses_total integer DEFAULT '-1'::integer,
    uses_remaining integer,
    used_count integer DEFAULT 0,
    active boolean DEFAULT true,
    starts_at timestamp without time zone,
    expires_at timestamp without time zone,
    created_by character varying(255),
    description text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 216 (class 1259 OID 24838)
-- Name: promo_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promo_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 216
-- Name: promo_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promo_codes_id_seq OWNED BY public.promo_codes.id;


--
-- TOC entry 221 (class 1259 OID 24879)
-- Name: subscription_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_history (
    id integer NOT NULL,
    user_id character varying(255),
    event_type character varying(50) NOT NULL,
    old_status character varying(50),
    new_status character varying(50),
    old_end_date timestamp without time zone,
    new_end_date timestamp without time zone,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 220 (class 1259 OID 24878)
-- Name: subscription_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscription_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 220
-- Name: subscription_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscription_history_id_seq OWNED BY public.subscription_history.id;


--
-- TOC entry 242 (class 1259 OID 25124)
-- Name: trial_usage_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trial_usage_history (
    id integer NOT NULL,
    original_transaction_id character varying(255) NOT NULL,
    user_id uuid,
    apple_product_id character varying(255),
    had_intro_offer boolean DEFAULT false,
    had_free_trial boolean DEFAULT false,
    trial_start_date timestamp without time zone,
    trial_end_date timestamp without time zone,
    apple_environment character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE trial_usage_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.trial_usage_history IS 'Tracks which Apple original_transaction_ids have received trials. 
This table persists even when user accounts are deleted to prevent trial abuse.
The original_transaction_id is tied to the Apple ID, not our user account.
This is minimal, purpose-limited data retained only for fraud prevention (GDPR/CCPA compliant).';


--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN trial_usage_history.original_transaction_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.trial_usage_history.original_transaction_id IS 'Apple''s stable identifier that persists across renewals and restores. 
Tied to the user''s Apple ID, not our app account.';


--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN trial_usage_history.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.trial_usage_history.user_id IS 'Reference to our user account. Set to NULL when account is deleted for privacy.';


--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN trial_usage_history.had_intro_offer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.trial_usage_history.had_intro_offer IS 'True if this transaction used any introductory offer (includes free trials and discounted periods).';


--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN trial_usage_history.had_free_trial; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.trial_usage_history.had_free_trial IS 'True if this transaction specifically used a free trial period.';


--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN trial_usage_history.apple_environment; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.trial_usage_history.apple_environment IS 'Sandbox or Production - helps distinguish test vs real subscriptions.';


--
-- TOC entry 241 (class 1259 OID 25123)
-- Name: trial_usage_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trial_usage_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 241
-- Name: trial_usage_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trial_usage_history_id_seq OWNED BY public.trial_usage_history.id;


--
-- TOC entry 234 (class 1259 OID 25071)
-- Name: user_api_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_api_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 234
-- Name: user_api_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_api_usage_id_seq OWNED BY public.user_api_usage.id;


--
-- TOC entry 233 (class 1259 OID 25028)
-- Name: user_devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_devices (
    user_id character varying(255) NOT NULL,
    device_id character varying(255) NOT NULL,
    device_name character varying(255),
    is_trusted boolean DEFAULT false,
    first_seen timestamp without time zone DEFAULT now(),
    last_seen timestamp without time zone DEFAULT now(),
    login_count integer DEFAULT 1
);


--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE user_devices; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.user_devices IS 'Stores user device preferences and trusted device status';


--
-- TOC entry 243 (class 1259 OID 25143)
-- Name: user_entitlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_entitlements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id text NOT NULL,
    subscription_group_id text NOT NULL,
    original_transaction_id text,
    original_transaction_id_hash text,
    is_trial boolean DEFAULT false NOT NULL,
    status text NOT NULL,
    purchase_at timestamp with time zone,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT user_entitlements_status_check CHECK ((status = ANY (ARRAY['active'::text, 'expired'::text, 'canceled'::text])))
);


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE user_entitlements; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.user_entitlements IS 'User-linked subscription entitlements. Contains PII and plain transaction IDs 
while user account exists. Deleted on account deletion (data mirrored to 
entitlements_ledger first).';


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN user_entitlements.original_transaction_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_entitlements.original_transaction_id IS 'Plain Apple original_transaction_id. Kept only while user exists. Deleted on 
account deletion after mirroring hash to entitlements_ledger.';


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 243
-- Name: COLUMN user_entitlements.original_transaction_id_hash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_entitlements.original_transaction_id_hash IS 'Hashed version of original_transaction_id. Used to link to entitlements_ledger 
and for de-identified lookups after account deletion.';


--
-- TOC entry 236 (class 1259 OID 25090)
-- Name: user_usage_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.user_usage_summary AS
 SELECT u.user_id,
    u.username,
    u.email,
    count(uau.id) AS total_api_calls,
    sum(uau.prompt_tokens) AS total_prompt_tokens,
    sum(uau.completion_tokens) AS total_completion_tokens,
    sum(uau.total_tokens) AS total_tokens,
    sum(uau.cost_usd) AS total_cost_usd,
    max(uau.created_at) AS last_api_call,
    min(uau.created_at) AS first_api_call
   FROM (public.users u
     LEFT JOIN public.user_api_usage uau ON (((u.user_id)::text = (uau.user_id)::text)))
  GROUP BY u.user_id, u.username, u.email
  ORDER BY (sum(uau.cost_usd)) DESC NULLS LAST;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 236
-- Name: VIEW user_usage_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.user_usage_summary IS 'Aggregated view of API usage per user';


--
-- TOC entry 214 (class 1259 OID 24816)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4069 (class 2604 OID 25180)
-- Name: admin_audit_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_audit_log ALTER COLUMN id SET DEFAULT nextval('public.admin_audit_log_id_seq'::regclass);


--
-- TOC entry 4032 (class 2604 OID 24900)
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- TOC entry 4039 (class 2604 OID 25002)
-- Name: device_logins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_logins ALTER COLUMN id SET DEFAULT nextval('public.device_logins_id_seq'::regclass);


--
-- TOC entry 4042 (class 2604 OID 25016)
-- Name: fraud_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fraud_flags ALTER COLUMN id SET DEFAULT nextval('public.fraud_flags_id_seq'::regclass);


--
-- TOC entry 4071 (class 2604 OID 25193)
-- Name: homework_submissions submission_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homework_submissions ALTER COLUMN submission_id SET DEFAULT nextval('public.homework_submissions_submission_id_seq'::regclass);


--
-- TOC entry 4036 (class 2604 OID 24946)
-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


--
-- TOC entry 4028 (class 2604 OID 24860)
-- Name: promo_code_usage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_code_usage ALTER COLUMN id SET DEFAULT nextval('public.promo_code_usage_id_seq'::regclass);


--
-- TOC entry 4023 (class 2604 OID 24842)
-- Name: promo_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_codes ALTER COLUMN id SET DEFAULT nextval('public.promo_codes_id_seq'::regclass);


--
-- TOC entry 4030 (class 2604 OID 24882)
-- Name: subscription_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_history ALTER COLUMN id SET DEFAULT nextval('public.subscription_history_id_seq'::regclass);


--
-- TOC entry 4056 (class 2604 OID 25127)
-- Name: trial_usage_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trial_usage_history ALTER COLUMN id SET DEFAULT nextval('public.trial_usage_history_id_seq'::regclass);


--
-- TOC entry 4050 (class 2604 OID 25075)
-- Name: user_api_usage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_api_usage ALTER COLUMN id SET DEFAULT nextval('public.user_api_usage_id_seq'::regclass);


--
-- TOC entry 4014 (class 2604 OID 24820)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4363 (class 0 OID 25177)
-- Dependencies: 246
-- Data for Name: admin_audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_audit_log (id, admin_user_id, admin_username, admin_email, action, target_type, target_id, target_email, target_username, details, ip_address, user_agent, created_at) FROM stdin;
1	system	system	system@homeworkhelper.com	table_created	\N	\N	\N	\N	admin_audit_log table created via API	127.0.0.1	api-migration	2025-10-17 02:57:09.270872
2	system	system	system@homeworkhelper.com	table_created	\N	\N	\N	\N	admin_audit_log table created via API	127.0.0.1	api-migration	2025-10-17 03:17:42.810665
3	system	system	system@homeworkhelper.com	table_created	\N	\N	\N	\N	admin_audit_log table created via API	127.0.0.1	api-migration	2025-10-17 03:20:55.287003
\.


--
-- TOC entry 4348 (class 0 OID 24897)
-- Dependencies: 223
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_users (id, username, email, password_hash, role, is_active, created_at, last_login) FROM stdin;
9	admin	support_homework@arshia.com	5dbb0b12436be7483ef1b7c765ad195dba10efa46a4ac6f736ccf614631b9bb4	admin	t	2025-10-17 18:43:42.933162	2025-10-17 20:44:04.65934
\.


--
-- TOC entry 4352 (class 0 OID 24999)
-- Dependencies: 230
-- Data for Name: device_logins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_logins (id, user_id, device_id, login_time, ip_address, user_agent, device_info, created_at) FROM stdin;
1	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:02:08.787697	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:02:08.787697
2	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:02:47.776797	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:02:47.776797
3	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:18:26.070511	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:18:26.070511
4	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:18:33.896733	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:18:33.896733
5	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:18:50.912902	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:18:50.912902
6	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:19:02.382436	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:19:02.382436
7	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:19:08.524433	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:19:08.524433
8	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:23:46.623848	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:23:46.623848
9	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:24:24.500211	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:24:24.500211
10	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:25:09.881327	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:25:09.881327
11	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:25:25.960461	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:25:25.960461
12	33bc2695-7dcf-4109-bb70-ffc6fcb958a8	test-device	2025-10-09 21:27:51.733292	::ffff:169.254.130.1	curl/8.7.1	{"appBuild": "1", "deviceId": "test-device", "platform": "iOS", "appVersion": "1.0.0", "deviceName": "Test iPhone", "deviceModel": "iPhone", "systemVersion": "18.0"}	2025-10-09 21:27:51.733292
13	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:27:51.734916	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:27:51.734916
14	610b14cb-c446-46b7-bcac-e0565e7ea5ea	test-device-123	2025-10-09 21:28:03.195719	::ffff:169.254.130.1	curl/8.7.1	{"appBuild": "1", "deviceId": "test-device-123", "platform": "iOS", "appVersion": "1.0.0", "deviceName": "Test iPhone", "deviceModel": "iPhone", "systemVersion": "18.0"}	2025-10-09 21:28:03.195719
15	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:28:14.840881	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:28:14.840881
16	8ca1bd33-89e6-4508-92df-872fc8450ef4	unknown	2025-10-09 21:28:57.619873	::ffff:169.254.130.1	HomeworkHelper/6 CFNetwork/3826.600.41 Darwin/24.6.0	{}	2025-10-09 21:28:57.619873
17	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 21:46:02.915458	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 21:46:02.915458
18	3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 22:34:59.04076	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 22:34:59.04076
19	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 22:53:03.736021	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 22:53:03.736021
20	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-09 23:28:10.722787	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-09 23:28:10.722787
21	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-10 02:11:30.908729	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-10 02:11:30.908729
22	81ec2385-7f7f-4db8-89b9-204d0c24a1df	unknown	2025-10-10 17:15:26.507824	::ffff:169.254.130.1	HomeworkHelper/6 CFNetwork/3826.600.41 Darwin/24.6.0	{}	2025-10-10 17:15:26.507824
23	fc06e3c3-d68e-42aa-b584-b0a59ae8c718	unknown	2025-10-10 17:35:11.048002	::ffff:169.254.130.1	HomeworkHelper/6 CFNetwork/3826.600.41 Darwin/24.6.0	{}	2025-10-10 17:35:11.048002
24	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-10 17:44:16.66498	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-10 17:44:16.66498
25	81ec2385-7f7f-4db8-89b9-204d0c24a1df	unknown	2025-10-10 17:52:42.936169	::ffff:169.254.130.1	HomeworkHelper/6 CFNetwork/3826.600.41 Darwin/24.6.0	{}	2025-10-10 17:52:42.936169
26	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	2025-10-10 17:56:03.952949	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-10 17:56:03.952949
27	f30fe78c-277e-432e-a1f6-83c4fad36837	unknown	2025-10-10 19:12:25.237441	::ffff:169.254.130.1	HomeworkHelper/6 CFNetwork/3860.100.1 Darwin/25.0.0	{}	2025-10-10 19:12:25.237441
28	f30fe78c-277e-432e-a1f6-83c4fad36837	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	2025-10-10 23:38:35.591041	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "5C075B04-25B8-4915-A49A-0E1EF0E5C6B3", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-10 23:38:35.591041
29	3797d874-5599-4844-8d6d-e1958e11d82a	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	2025-10-11 00:12:45.466793	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "5C075B04-25B8-4915-A49A-0E1EF0E5C6B3", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 00:12:45.466793
30	f30fe78c-277e-432e-a1f6-83c4fad36837	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	2025-10-11 00:48:36.261761	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "5C075B04-25B8-4915-A49A-0E1EF0E5C6B3", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 00:48:36.261761
31	3797d874-5599-4844-8d6d-e1958e11d82a	AC10B57F-4137-4F20-9C76-A7C9540F387E	2025-10-11 03:32:05.432439	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "AC10B57F-4137-4F20-9C76-A7C9540F387E", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 03:32:05.432439
32	f30fe78c-277e-432e-a1f6-83c4fad36837	7475847D-E5AC-4675-84BC-28BECB336E35	2025-10-11 04:09:19.837584	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "7475847D-E5AC-4675-84BC-28BECB336E35", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 04:09:19.837584
33	3797d874-5599-4844-8d6d-e1958e11d82a	1EC2C674-60A2-42C5-8D8E-760561CFDD32	2025-10-11 04:13:05.007224	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "1EC2C674-60A2-42C5-8D8E-760561CFDD32", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 04:13:05.007224
34	f30fe78c-277e-432e-a1f6-83c4fad36837	F877F805-6C36-4648-8024-A739638B1DFE	2025-10-11 04:24:21.729447	::ffff:169.254.130.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "F877F805-6C36-4648-8024-A739638B1DFE", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 04:24:21.729447
35	3797d874-5599-4844-8d6d-e1958e11d82a	196A465D-D76E-4029-8835-4CCCCCD38612	2025-10-11 17:42:59.530424	::ffff:169.254.130.1	HomeworkHelper/7 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "7", "deviceId": "196A465D-D76E-4029-8835-4CCCCCD38612", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 17:42:59.530424
36	f30fe78c-277e-432e-a1f6-83c4fad36837	F877F805-6C36-4648-8024-A739638B1DFE	2025-10-11 19:21:54.565275	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "F877F805-6C36-4648-8024-A739638B1DFE", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 19:21:54.565275
37	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:22:27.200392	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:22:27.200392
38	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:23:06.787313	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:23:06.787313
39	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:25:10.86041	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:25:10.86041
40	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:26:38.585424	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:26:38.585424
41	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:29:30.966168	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:29:30.966168
42	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:38:22.3629	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:38:22.3629
43	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:52:48.583747	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:52:48.583747
44	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:53:57.125922	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:53:57.125922
45	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:54:15.584119	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:54:15.584119
46	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:54:37.972963	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:54:37.972963
47	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 20:55:19.295669	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 20:55:19.295669
48	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 21:50:11.805934	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 21:50:11.805934
49	db27c446-cab9-40dc-b5a3-1b9863c8437f	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-11 21:56:41.176814	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 21:56:41.176814
50	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	196A465D-D76E-4029-8835-4CCCCCD38612	2025-10-11 23:46:53.719741	::ffff:172.16.0.1	HomeworkHelper/7 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "7", "deviceId": "196A465D-D76E-4029-8835-4CCCCCD38612", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-11 23:46:53.719741
51	db27c446-cab9-40dc-b5a3-1b9863c8437f	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 01:23:22.036804	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 01:23:22.036804
52	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 01:25:42.477819	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 01:25:42.477819
53	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 01:51:15.144088	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 01:51:15.144088
54	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 02:54:53.476287	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 02:54:53.476287
55	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 02:59:52.289753	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 02:59:52.289753
56	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 03:05:18.600849	::ffff:172.16.0.1	HomeworkHelper/8 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "8", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 03:05:18.600849
57	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 17:39:08.837684	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 17:39:08.837684
58	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 19:25:10.581266	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 19:25:10.581266
59	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 19:41:18.105652	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 19:41:18.105652
60	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 19:47:03.162795	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 19:47:03.162795
61	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 20:10:37.850862	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 20:10:37.850862
62	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 21:13:03.726654	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 21:13:03.726654
63	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 21:34:21.724882	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 21:34:21.724882
64	f430a463-c285-4ab3-a8d5-7fd38f0c5f85	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 21:44:41.723649	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 21:44:41.723649
65	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 21:48:49.802316	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 21:48:49.802316
66	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 22:00:16.19502	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 22:00:16.19502
67	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 23:55:12.808342	::ffff:172.16.0.1	HomeworkHelper/9 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "9", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 23:55:12.808342
68	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-12 23:55:48.304791	::ffff:172.16.0.1	HomeworkHelper/9 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "9", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-12 23:55:48.304791
69	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 00:43:04.264849	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "20", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 00:43:04.264849
70	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 00:45:33.4894	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "20", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 00:45:33.4894
71	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 00:48:26.423336	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "20", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 00:48:26.423336
72	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 17:52:59.685044	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "2.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 17:52:59.685044
73	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 21:59:40.567385	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 21:59:40.567385
74	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-13 22:01:13.26414	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-13 22:01:13.26414
75	82c463e3-8349-4657-96a1-99ef136c9163	1CA248AE-2252-4F35-9C7B-310490274514	2025-10-14 04:25:04.785668	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3826.400.120 Darwin/24.3.0	{"appBuild": "1", "deviceId": "1CA248AE-2252-4F35-9C7B-310490274514", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "18.3.2"}	2025-10-14 04:25:04.785668
76	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 04:28:03.88611	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 04:28:03.88611
77	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 04:28:45.861902	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 04:28:45.861902
78	71cc27f6-5272-435c-a326-5853af953e77	7128365C-CB0B-4430-9333-6AA2CD7F5C1A	2025-10-14 17:47:21.701396	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "7128365C-CB0B-4430-9333-6AA2CD7F5C1A", "platform": "iOS", "appVersion": "3", "deviceName": "iPad", "deviceModel": "iPad", "systemVersion": "26.0.1"}	2025-10-14 17:47:21.701396
79	8511b345-0d92-4c84-95a2-9d3483c8829e	FDA2BCA6-6C1A-4681-99BC-450713EDC958	2025-10-14 21:25:09.925748	::ffff:172.16.0.1	HomeworkHelper/1 CFNetwork/3826.600.41 Darwin/24.6.0	{"appBuild": "1", "deviceId": "FDA2BCA6-6C1A-4681-99BC-450713EDC958", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "18.6.2"}	2025-10-14 21:25:09.925748
80	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 23:25:57.330765	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 23:25:57.330765
81	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 23:26:36.39566	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 23:26:36.39566
82	8726319a-70fc-4e6b-8b00-d5a9f8c8e155	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 23:41:57.593916	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 23:41:57.593916
83	e64cac7b-7b6e-4609-adfd-5c648758b000	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-14 23:42:58.541858	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-14 23:42:58.541858
84	4fb71701-c436-49ab-950b-6b32b0141897	unknown	2025-10-15 00:10:50.619892	::ffff:172.16.0.1	curl/8.7.1	{}	2025-10-15 00:10:50.619892
85	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 01:11:25.657734	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 01:11:25.657734
86	e64cac7b-7b6e-4609-adfd-5c648758b000	2A4BDB43-B4BB-46BD-9368-2E205BD95D08	2025-10-15 02:53:47.611622	::ffff:172.16.0.1	Homework%20HelperDev/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2A4BDB43-B4BB-46BD-9368-2E205BD95D08", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 02:53:47.611622
87	e64cac7b-7b6e-4609-adfd-5c648758b000	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 02:57:46.285499	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 02:57:46.285499
88	ba57e63c-23bb-44d0-99a7-052c309b5b2b	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 02:58:18.438859	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 02:58:18.438859
89	515a3b0b-5105-445b-aaa0-06c9432a01a7	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 02:59:36.222466	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 02:59:36.222466
90	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 03:05:25.401429	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 03:05:25.401429
91	b1cfd676-d3dd-4979-9bef-7d79e7c36297	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-15 03:05:51.449806	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 03:05:51.449806
92	515a3b0b-5105-445b-aaa0-06c9432a01a7	2A4BDB43-B4BB-46BD-9368-2E205BD95D08	2025-10-15 22:13:49.703102	::ffff:172.16.0.1	Homework%20HelperStaging/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2A4BDB43-B4BB-46BD-9368-2E205BD95D08", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-15 22:13:49.703102
93	515a3b0b-5105-445b-aaa0-06c9432a01a7	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-16 22:18:10.413521	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-16 22:18:10.413521
94	96bca4a5-cca8-4855-a41e-932b741d57c3	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-16 22:19:31.96101	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-16 22:19:31.96101
95	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-16 22:23:09.218973	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-16 22:23:09.218973
96	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-16 22:24:01.698025	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-16 22:24:01.698025
97	85453e87-deff-41d6-9e32-d3fc38eee454	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-16 22:24:25.068854	::ffff:172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-16 22:24:25.068854
98	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 00:15:11.895363	172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 00:15:11.895363
99	b1cfd676-d3dd-4979-9bef-7d79e7c36297	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 19:09:51.452783	172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 19:09:51.452783
100	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 19:33:45.688995	172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "1.0", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 19:33:45.688995
101	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	unknown	2025-10-17 20:15:29.475811	172.16.0.1	HomeworkHelper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{}	2025-10-17 20:15:29.475811
102	33bc2695-7dcf-4109-bb70-ffc6fcb958a8	unknown	2025-10-17 20:27:00.348281	172.16.0.1	curl/8.7.1	{"version": "17.0", "platform": "iOS"}	2025-10-17 20:27:00.348281
103	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 20:28:21.71353	172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 20:28:21.71353
104	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 20:53:08.248811	172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 20:53:08.248811
105	85453e87-deff-41d6-9e32-d3fc38eee454	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	2025-10-17 20:57:59.304881	172.16.0.1	Homework%20Helper/1 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "1", "deviceId": "2CACD9BD-47E4-4F81-8DFA-4E481AA74E86", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0.1"}	2025-10-17 20:57:59.304881
106	3e3f2acf-0203-4e90-a862-b4d9306c2f45	32E10282-BB25-4566-BEFB-5F5CEDECF8FD	2025-10-17 21:28:36.96398	172.16.0.1	Homework%20Helper/3 CFNetwork/3860.100.1 Darwin/25.0.0	{"appBuild": "3", "deviceId": "32E10282-BB25-4566-BEFB-5F5CEDECF8FD", "platform": "iOS", "appVersion": "3", "deviceName": "iPhone", "deviceModel": "iPhone", "systemVersion": "26.0"}	2025-10-17 21:28:36.96398
\.


--
-- TOC entry 4361 (class 0 OID 25160)
-- Dependencies: 244
-- Data for Name: entitlements_ledger; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.entitlements_ledger (id, product_id, subscription_group_id, original_transaction_id_hash, ever_trial, status, first_seen_at, last_seen_at) FROM stdin;
2dfdc943-49ae-4948-8879-d370cb9e1014	com.homeworkhelper.monthly	homework_helper_subscriptions	9e6ca24ba9b22439ac60ed743449dc9660438ce16fcfd2992e85d2bdbe386501	f	active	2025-10-17 00:09:40.041+00	2025-10-17 00:09:40.041+00
d79cf0c8-f715-4722-afe1-742381efc15b	com.homeworkhelper.yearly	homework_helper_subscriptions	cbaf06e7aa4e057756ea266c15967afe291ed2096ee9bf467dccc3b832475ab6	t	active	2025-10-17 00:09:40.181+00	2025-10-17 00:09:40.181+00
7523a537-536d-40ef-9c71-1b20a46897ca	com.homeworkhelper.monthly	homework_helper_subscriptions	7de263a580e0ea9942841f2a9915a7a3793b163f10b3dac933af681c98d36b61	t	expired	2025-10-17 00:09:40.264+00	2025-10-17 00:09:40.264+00
4e9376f3-003f-49cc-81b8-19b2b130fcc6	com.homeworkhelper.yearly	homework_helper_subscriptions	bba2c51428802e68bba051ee9eef4a021a7eafbe60ff29e2f80c9e6c47bdb0eb	f	canceled	2025-10-17 00:09:40.294+00	2025-10-17 00:09:40.294+00
\.


--
-- TOC entry 4354 (class 0 OID 25013)
-- Dependencies: 232
-- Data for Name: fraud_flags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fraud_flags (id, user_id, device_id, reason, severity, details, resolved, resolved_at, resolved_by, created_at) FROM stdin;
1	f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-09T21:02:08.875Z"}	f	\N	\N	2025-10-09 21:02:08.892245
2	33bc2695-7dcf-4109-bb70-ffc6fcb958a8	test-device	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-09T21:27:51.827Z"}	f	\N	\N	2025-10-09 21:27:51.827765
3	610b14cb-c446-46b7-bcac-e0565e7ea5ea	test-device-123	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-09T21:28:03.224Z"}	f	\N	\N	2025-10-09 21:28:03.224633
4	8ca1bd33-89e6-4508-92df-872fc8450ef4	unknown	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-09T21:28:57.632Z"}	f	\N	\N	2025-10-09 21:28:57.63272
5	f30fe78c-277e-432e-a1f6-83c4fad36837	unknown	multiple_accounts_per_device:4	medium	{"patterns": ["multiple_accounts_per_device:4"], "timestamp": "2025-10-10T19:12:25.368Z"}	f	\N	\N	2025-10-10 19:12:25.369617
6	f30fe78c-277e-432e-a1f6-83c4fad36837	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-10T23:38:35.608Z"}	f	\N	\N	2025-10-10 23:38:35.609935
7	3797d874-5599-4844-8d6d-e1958e11d82a	AC10B57F-4137-4F20-9C76-A7C9540F387E	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T03:32:05.444Z"}	f	\N	\N	2025-10-11 03:32:05.444925
8	f30fe78c-277e-432e-a1f6-83c4fad36837	7475847D-E5AC-4675-84BC-28BECB336E35	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T04:09:19.871Z"}	f	\N	\N	2025-10-11 04:09:19.871858
9	3797d874-5599-4844-8d6d-e1958e11d82a	1EC2C674-60A2-42C5-8D8E-760561CFDD32	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T04:13:05.028Z"}	f	\N	\N	2025-10-11 04:13:05.028455
10	f30fe78c-277e-432e-a1f6-83c4fad36837	F877F805-6C36-4648-8024-A739638B1DFE	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T04:24:21.749Z"}	f	\N	\N	2025-10-11 04:24:21.750347
11	3797d874-5599-4844-8d6d-e1958e11d82a	196A465D-D76E-4029-8835-4CCCCCD38612	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T17:42:59.584Z"}	f	\N	\N	2025-10-11 17:42:59.588666
12	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-11T20:22:27.217Z"}	f	\N	\N	2025-10-11 20:22:27.222027
13	db27c446-cab9-40dc-b5a3-1b9863c8437f	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:4	medium	{"patterns": ["multiple_accounts_per_device:4"], "timestamp": "2025-10-11T21:56:41.232Z"}	f	\N	\N	2025-10-11 21:56:41.236453
14	db27c446-cab9-40dc-b5a3-1b9863c8437f	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:4	medium	{"patterns": ["multiple_accounts_per_device:4"], "timestamp": "2025-10-12T01:23:22.070Z"}	f	\N	\N	2025-10-12 01:23:22.074424
15	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T01:25:42.507Z"}	f	\N	\N	2025-10-12 01:25:42.512324
16	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T01:51:15.157Z"}	f	\N	\N	2025-10-12 01:51:15.161444
17	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T02:54:53.487Z"}	f	\N	\N	2025-10-12 02:54:53.490984
18	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T02:59:52.302Z"}	f	\N	\N	2025-10-12 02:59:52.306326
19	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T03:05:18.614Z"}	f	\N	\N	2025-10-12 03:05:18.617471
20	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T17:39:08.854Z"}	f	\N	\N	2025-10-12 17:39:08.856605
21	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T19:25:10.609Z"}	f	\N	\N	2025-10-12 19:25:10.61093
22	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T19:41:18.123Z"}	f	\N	\N	2025-10-12 19:41:18.12539
23	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T19:47:03.178Z"}	f	\N	\N	2025-10-12 19:47:03.180594
24	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T20:10:37.895Z"}	f	\N	\N	2025-10-12 20:10:37.897864
25	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T21:13:03.793Z"}	f	\N	\N	2025-10-12 21:13:03.795566
26	d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-12T21:34:21.744Z"}	f	\N	\N	2025-10-12 21:34:21.746178
27	f430a463-c285-4ab3-a8d5-7fd38f0c5f85	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:6	high	{"patterns": ["excessive_accounts_per_device:6"], "timestamp": "2025-10-12T21:44:41.750Z"}	f	\N	\N	2025-10-12 21:44:41.752143
28	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:6, rapid_account_switching:4	high	{"patterns": ["excessive_accounts_per_device:6", "rapid_account_switching:4"], "timestamp": "2025-10-12T21:48:49.816Z"}	f	\N	\N	2025-10-12 21:48:49.818102
29	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:7, rapid_account_switching:5	high	{"patterns": ["excessive_accounts_per_device:7", "rapid_account_switching:5"], "timestamp": "2025-10-12T22:00:16.210Z"}	f	\N	\N	2025-10-12 22:00:16.212228
30	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:8	high	{"patterns": ["excessive_accounts_per_device:8"], "timestamp": "2025-10-12T23:55:12.835Z"}	f	\N	\N	2025-10-12 23:55:12.836798
31	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-12T23:55:48.319Z"}	f	\N	\N	2025-10-12 23:55:48.321439
32	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T00:43:04.323Z"}	f	\N	\N	2025-10-13 00:43:04.324635
33	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T00:45:33.516Z"}	f	\N	\N	2025-10-13 00:45:33.517558
34	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T00:48:26.448Z"}	f	\N	\N	2025-10-13 00:48:26.449757
35	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T17:52:59.753Z"}	f	\N	\N	2025-10-13 17:52:59.754434
36	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T21:59:40.584Z"}	f	\N	\N	2025-10-13 21:59:40.586752
37	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-13T22:01:13.280Z"}	f	\N	\N	2025-10-13 22:01:13.282868
38	82c463e3-8349-4657-96a1-99ef136c9163	1CA248AE-2252-4F35-9C7B-310490274514	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-14T04:25:04.797Z"}	f	\N	\N	2025-10-14 04:25:04.800808
39	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-14T04:28:03.933Z"}	f	\N	\N	2025-10-14 04:28:03.954526
40	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-14T04:28:45.870Z"}	f	\N	\N	2025-10-14 04:28:45.874075
41	71cc27f6-5272-435c-a326-5853af953e77	7128365C-CB0B-4430-9333-6AA2CD7F5C1A	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-14T17:47:21.768Z"}	f	\N	\N	2025-10-14 17:47:21.790312
42	8511b345-0d92-4c84-95a2-9d3483c8829e	FDA2BCA6-6C1A-4681-99BC-450713EDC958	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-14T21:25:09.989Z"}	f	\N	\N	2025-10-14 21:25:09.992591
43	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-14T23:25:57.347Z"}	f	\N	\N	2025-10-14 23:25:57.349803
44	898913d2-1fa5-4da3-988b-17791953b04c	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:9	high	{"patterns": ["excessive_accounts_per_device:9"], "timestamp": "2025-10-14T23:26:36.419Z"}	f	\N	\N	2025-10-14 23:26:36.42131
45	8726319a-70fc-4e6b-8b00-d5a9f8c8e155	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:10	high	{"patterns": ["excessive_accounts_per_device:10"], "timestamp": "2025-10-14T23:41:57.607Z"}	f	\N	\N	2025-10-14 23:41:57.609484
46	e64cac7b-7b6e-4609-adfd-5c648758b000	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:11, rapid_account_switching:4	high	{"patterns": ["excessive_accounts_per_device:11", "rapid_account_switching:4"], "timestamp": "2025-10-14T23:42:58.552Z"}	f	\N	\N	2025-10-14 23:42:58.555237
47	4fb71701-c436-49ab-950b-6b32b0141897	unknown	multiple_accounts_per_device:5	medium	{"patterns": ["multiple_accounts_per_device:5"], "timestamp": "2025-10-15T00:10:50.635Z"}	f	\N	\N	2025-10-15 00:10:50.63927
48	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:11	high	{"patterns": ["excessive_accounts_per_device:11"], "timestamp": "2025-10-15T01:11:25.675Z"}	f	\N	\N	2025-10-15 01:11:25.677449
49	e64cac7b-7b6e-4609-adfd-5c648758b000	2A4BDB43-B4BB-46BD-9368-2E205BD95D08	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-15T02:53:47.626Z"}	f	\N	\N	2025-10-15 02:53:47.629125
50	e64cac7b-7b6e-4609-adfd-5c648758b000	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:11	high	{"patterns": ["excessive_accounts_per_device:11"], "timestamp": "2025-10-15T02:57:46.299Z"}	f	\N	\N	2025-10-15 02:57:46.30218
51	ba57e63c-23bb-44d0-99a7-052c309b5b2b	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:12	high	{"patterns": ["excessive_accounts_per_device:12"], "timestamp": "2025-10-15T02:58:18.449Z"}	f	\N	\N	2025-10-15 02:58:18.452177
52	515a3b0b-5105-445b-aaa0-06c9432a01a7	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:13	high	{"patterns": ["excessive_accounts_per_device:13"], "timestamp": "2025-10-15T02:59:36.234Z"}	f	\N	\N	2025-10-15 02:59:36.236754
53	0e23b50a-77dd-43c9-a0cb-2b980c349995	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:13, rapid_account_switching:4	high	{"patterns": ["excessive_accounts_per_device:13", "rapid_account_switching:4"], "timestamp": "2025-10-15T03:05:25.416Z"}	f	\N	\N	2025-10-15 03:05:25.418713
54	b1cfd676-d3dd-4979-9bef-7d79e7c36297	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:14, rapid_account_switching:5	high	{"patterns": ["excessive_accounts_per_device:14", "rapid_account_switching:5"], "timestamp": "2025-10-15T03:05:51.475Z"}	f	\N	\N	2025-10-15 03:05:51.477498
55	515a3b0b-5105-445b-aaa0-06c9432a01a7	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:14	high	{"patterns": ["excessive_accounts_per_device:14"], "timestamp": "2025-10-16T22:18:10.441Z"}	f	\N	\N	2025-10-16 22:18:10.444793
56	96bca4a5-cca8-4855-a41e-932b741d57c3	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:15	high	{"patterns": ["excessive_accounts_per_device:15"], "timestamp": "2025-10-16T22:19:31.999Z"}	f	\N	\N	2025-10-16 22:19:32.001468
57	c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:15	high	{"patterns": ["excessive_accounts_per_device:15"], "timestamp": "2025-10-16T22:23:09.237Z"}	f	\N	\N	2025-10-16 22:23:09.239089
58	25fa3bf5-4846-436b-afc8-8f95213a56a6	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:15, rapid_account_switching:4	high	{"patterns": ["excessive_accounts_per_device:15", "rapid_account_switching:4"], "timestamp": "2025-10-16T22:24:01.714Z"}	f	\N	\N	2025-10-16 22:24:01.715714
59	85453e87-deff-41d6-9e32-d3fc38eee454	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:16, rapid_account_switching:5	high	{"patterns": ["excessive_accounts_per_device:16", "rapid_account_switching:5"], "timestamp": "2025-10-16T22:24:25.089Z"}	f	\N	\N	2025-10-16 22:24:25.091295
60	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T00:15:11.909Z"}	f	\N	\N	2025-10-17 00:15:11.911465
61	b1cfd676-d3dd-4979-9bef-7d79e7c36297	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T19:09:51.551Z"}	f	\N	\N	2025-10-17 19:09:51.552733
62	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T19:33:45.757Z"}	f	\N	\N	2025-10-17 19:33:45.759462
63	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T20:28:21.727Z"}	f	\N	\N	2025-10-17 20:28:21.729531
64	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T20:53:08.264Z"}	f	\N	\N	2025-10-17 20:53:08.266184
65	85453e87-deff-41d6-9e32-d3fc38eee454	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	excessive_accounts_per_device:17	high	{"patterns": ["excessive_accounts_per_device:17"], "timestamp": "2025-10-17T20:57:59.334Z"}	f	\N	\N	2025-10-17 20:57:59.339609
66	3e3f2acf-0203-4e90-a862-b4d9306c2f45	32E10282-BB25-4566-BEFB-5F5CEDECF8FD	new_device_detected	low	{"patterns": ["new_device_detected"], "timestamp": "2025-10-17T21:28:36.983Z"}	f	\N	\N	2025-10-17 21:28:36.985143
\.


--
-- TOC entry 4365 (class 0 OID 25190)
-- Dependencies: 248
-- Data for Name: homework_submissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.homework_submissions (submission_id, user_id, problem_id, subject, problem_text, image_filename, total_steps, completed_steps, skipped_steps, status, time_spent_seconds, hints_used, submitted_at, completed_at) FROM stdin;
1	\N	F8B20F25-1408-43F6-9F39-EC0C9A42C4D4	Math		F8B20F25-1408-43F6-9F39-EC0C9A42C4D4.jpg	6	0	0	pending	0	0	2025-10-18 06:04:12.538203	\N
\.


--
-- TOC entry 4350 (class 0 OID 24943)
-- Dependencies: 228
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (id, user_id, token, expires_at, created_at, used, used_at) FROM stdin;
\.


--
-- TOC entry 4344 (class 0 OID 24857)
-- Dependencies: 219
-- Data for Name: promo_code_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promo_code_usage (id, promo_code_id, user_id, activated_at, ip_address) FROM stdin;
\.


--
-- TOC entry 4342 (class 0 OID 24839)
-- Dependencies: 217
-- Data for Name: promo_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promo_codes (id, code, duration_days, uses_total, uses_remaining, used_count, active, starts_at, expires_at, created_by, description, created_at) FROM stdin;
1	WELCOME2025	90	100	100	0	t	\N	\N	admin	Welcome promo - 3 months free	2025-10-06 18:37:38.562845
3	EARLYBIRD	180	20	20	0	t	\N	\N	admin	Early adopters - 6 months	2025-10-06 18:37:38.562845
2	STUDENT50	30	50	50	0	t	\N	\N	admin	Student discount - 1 month	2025-10-06 18:37:38.562845
\.


--
-- TOC entry 4346 (class 0 OID 24879)
-- Dependencies: 221
-- Data for Name: subscription_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subscription_history (id, user_id, event_type, old_status, new_status, old_end_date, new_end_date, metadata, created_at) FROM stdin;
71	c21dc002-5828-4cd6-b414-4ef55a6d8e31	trial_started	\N	trial	\N	2025-10-19 23:55:48.242	\N	2025-10-12 23:55:48.250391
72	3eb9d3cc-595d-402c-96ed-45439528954f	user_created_by_admin	\N	\N	\N	\N	{"admin": "admin"}	2025-10-13 20:55:44.736664
73	f6b7a96c-0c43-4b54-b25f-c419070bd59e	trial_started	\N	trial	\N	2025-10-20 21:09:48.047	\N	2025-10-13 21:09:48.053175
74	71cc27f6-5272-435c-a326-5853af953e77	trial_started	\N	trial	\N	2025-10-21 17:47:21.497	\N	2025-10-14 17:47:21.514646
75	8511b345-0d92-4c84-95a2-9d3483c8829e	trial_started	\N	trial	\N	2025-10-21 21:25:09.673	\N	2025-10-14 21:25:09.691226
78	4fb71701-c436-49ab-950b-6b32b0141897	account_created	\N	expired	\N	\N	\N	2025-10-15 00:10:50.533901
81	b1cfd676-d3dd-4979-9bef-7d79e7c36297	account_created	\N	expired	\N	\N	\N	2025-10-15 03:05:51.386706
83	85453e87-deff-41d6-9e32-d3fc38eee454	account_created	\N	expired	\N	\N	\N	2025-10-16 22:24:25.004812
84	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	account_created	\N	expired	\N	\N	\N	2025-10-17 00:15:11.791403
85	3e3f2acf-0203-4e90-a862-b4d9306c2f45	account_created	\N	expired	\N	\N	\N	2025-10-17 21:28:36.783198
47	82c463e3-8349-4657-96a1-99ef136c9163	trial_started	\N	trial	\N	2025-10-16 01:58:46.847	\N	2025-10-09 01:58:46.853282
48	f99ca211-365b-4127-8958-350920e0ade0	trial_started	\N	trial	\N	2025-10-16 02:47:19.581	\N	2025-10-09 02:47:19.689196
49	82c463e3-8349-4657-96a1-99ef136c9163	subscription_extended	\N	\N	\N	\N	{"admin": "admin", "days_added": 30}	2025-10-09 03:31:19.468399
50	82c463e3-8349-4657-96a1-99ef136c9163	subscription_extended	\N	\N	\N	\N	{"admin": "admin", "days_added": 90}	2025-10-09 03:32:32.2323
51	82c463e3-8349-4657-96a1-99ef136c9163	access_toggled	\N	\N	\N	\N	{"admin": "admin", "is_active": false}	2025-10-09 03:33:09.775153
52	82c463e3-8349-4657-96a1-99ef136c9163	access_toggled	\N	\N	\N	\N	{"admin": "admin", "is_active": true}	2025-10-09 03:34:01.304583
53	1c8e4891-b32b-4cc0-b104-b99607e8afa7	trial_started	\N	trial	\N	2025-10-16 04:14:37.589	\N	2025-10-09 04:14:37.601199
59	33bc2695-7dcf-4109-bb70-ffc6fcb958a8	trial_started	\N	trial	\N	2025-10-16 21:27:51.434	\N	2025-10-09 21:27:51.443147
60	610b14cb-c446-46b7-bcac-e0565e7ea5ea	trial_started	\N	trial	\N	2025-10-16 21:28:03.02	\N	2025-10-09 21:28:03.04006
61	8ca1bd33-89e6-4508-92df-872fc8450ef4	trial_started	\N	trial	\N	2025-10-16 21:28:57.561	\N	2025-10-09 21:28:57.567071
62	81ec2385-7f7f-4db8-89b9-204d0c24a1df	trial_started	\N	trial	\N	2025-10-17 17:15:26.353	\N	2025-10-10 17:15:26.36886
63	fc06e3c3-d68e-42aa-b584-b0a59ae8c718	trial_started	\N	trial	\N	2025-10-17 17:35:10.94	\N	2025-10-10 17:35:10.951236
\.


--
-- TOC entry 4359 (class 0 OID 25124)
-- Dependencies: 242
-- Data for Name: trial_usage_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trial_usage_history (id, original_transaction_id, user_id, apple_product_id, had_intro_offer, had_free_trial, trial_start_date, trial_end_date, apple_environment, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4357 (class 0 OID 25072)
-- Dependencies: 235
-- Data for Name: user_api_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_api_usage (id, user_id, endpoint, model, prompt_tokens, completion_tokens, total_tokens, cost_usd, problem_id, session_id, metadata, created_at, device_id) FROM stdin;
1	3797	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 18:58:09.958264	\N
2	3797	analyze_homework	gpt-4.1-mini	3503	358	3861	0.012338	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-11 18:58:17.214702	\N
3	3797d874-5599-4844-8d6d-e1958e11d82a	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 249553, "mimeType": "image/jpeg"}	2025-10-11 19:20:16.813466	\N
4	3797d874-5599-4844-8d6d-e1958e11d82a	analyze_homework	gpt-4.1-mini	3503	657	4160	0.015328	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-11 19:20:34.18839	\N
5	3797d874-5599-4844-8d6d-e1958e11d82a	generate_hint	gpt-4.1-mini	790	54	844	0.002515	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Is a map flat or round?"}	2025-10-11 19:20:36.180026	\N
6	3797d874-5599-4844-8d6d-e1958e11d82a	generate_hint	gpt-4.1-mini	832	82	914	0.002900	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Is a map flat or round?"}	2025-10-11 19:20:55.490508	\N
7	3797d874-5599-4844-8d6d-e1958e11d82a	generate_hint	gpt-4.1-mini	855	77	932	0.002908	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What kind of view does a map give us?"}	2025-10-11 19:21:00.889367	\N
8	f30fe78c-277e-432e-a1f6-83c4fad36837	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 19:22:24.714954	\N
9	f30fe78c-277e-432e-a1f6-83c4fad36837	analyze_homework	gpt-4.1-mini	3503	362	3865	0.012378	\N	\N	{"gradeLevel": "11th grade", "problemText": null}	2025-10-11 19:22:30.091331	\N
10	f30fe78c-277e-432e-a1f6-83c4fad36837	generate_hint	gpt-4.1-mini	795	47	842	0.002458	\N	\N	{"gradeLevel": "11th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 19:22:31.699924	\N
11	f30fe78c-277e-432e-a1f6-83c4fad36837	generate_hint	gpt-4.1-mini	871	72	943	0.002898	\N	\N	{"gradeLevel": "11th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 19:23:03.550541	\N
12	f30fe78c-277e-432e-a1f6-83c4fad36837	chat_response	gpt-4.1-mini	236	89	325	0.001480	\N	\N	{"gradeLevel": "11th grade", "messageCount": 1}	2025-10-11 19:23:20.957472	\N
13	f30fe78c-277e-432e-a1f6-83c4fad36837	generate_hint	gpt-4.1-mini	837	66	903	0.002753	\N	\N	{"gradeLevel": "11th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 19:29:40.70089	\N
14	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 231336, "mimeType": "image/jpeg"}	2025-10-11 20:24:13.885523	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
15	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	3503	430	3933	0.013058	\N	\N	{"gradeLevel": "10th grade", "problemText": null}	2025-10-11 20:24:22.216369	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
16	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	794	62	856	0.002605	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 1: Is a map flat or round?"}	2025-10-11 20:24:23.9279	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
17	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 20:25:31.471885	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
18	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	3503	366	3869	0.012418	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-11 20:25:39.388575	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
19	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	795	53	848	0.002518	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 20:25:41.216199	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
20	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 20:30:10.194483	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
21	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	3503	345	3848	0.012208	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-11 20:30:16.505265	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
22	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	787	53	840	0.002498	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 20:30:17.792314	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
23	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 20:53:36.241	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
24	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	3503	355	3858	0.012308	\N	\N	{"gradeLevel": "7th grade", "problemText": null}	2025-10-11 20:53:42.811592	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
25	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	795	50	845	0.002488	\N	\N	{"gradeLevel": "7th grade", "stepQuestion": "Problem 1: What change of state happens to ice cream in the summer?"}	2025-10-11 20:53:44.338472	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
401	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:02:57.423847	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
409	b1cfd676-d3dd-4979-9bef-7d79e7c36297	validate_image	gpt-4o-mini	37149	68	37217	0.005613	\N	\N	{"fileSize": 219226, "mimeType": "image/jpeg"}	2025-10-17 19:23:00.607932	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
410	b1cfd676-d3dd-4979-9bef-7d79e7c36297	analyze_homework	gpt-4o-mini	4744	250	4994	0.000862	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:23:06.552896	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
29	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2624	127	2751	0.007830	\N	\N	{"fileSize": 562402, "mimeType": "image/jpeg"}	2025-10-11 21:50:46.690939	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
30	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4193	82	4275	0.011303	\N	\N	{"gradeLevel": "9th grade", "problemText": null}	2025-10-11 21:50:50.296127	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
31	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4193	38	4231	0.010863	\N	\N	{"gradeLevel": "9th grade", "problemText": null}	2025-10-11 21:50:52.944051	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
32	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-11 21:51:15.72019	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
33	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	3503	365	3868	0.012408	\N	\N	{"gradeLevel": "9th grade", "problemText": null}	2025-10-11 21:51:21.437061	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
34	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	795	49	844	0.002478	\N	\N	{"gradeLevel": "9th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-11 21:51:23.17216	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
35	d4050ff7-da76-4a37-a1f6-585bbeda199d	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-12 01:39:59.642927	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
411	b1cfd676-d3dd-4979-9bef-7d79e7c36297	analyze_homework	gpt-4o-mini	4744	251	4995	0.000862	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:23:12.534693	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
36	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	3503	354	3857	0.012298	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 01:40:07.984874	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
37	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	793	46	839	0.002443	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 01:40:09.102705	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
38	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	869	60	929	0.002773	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 01:40:33.045371	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
39	d4050ff7-da76-4a37-a1f6-585bbeda199d	validate_image	gpt-4.1-mini	2713	30	2743	0.007083	\N	\N	{"fileSize": 129262, "mimeType": "image/jpeg"}	2025-10-12 02:53:10.123109	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
40	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	4282	509	4791	0.015795	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 02:53:18.44328	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
41	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	789	58	847	0.002553	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 02:53:19.687783	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
42	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	865	50	915	0.002663	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 02:53:30.268969	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
43	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	821	60	881	0.002653	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-12 02:53:37.313072	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
44	d4050ff7-da76-4a37-a1f6-585bbeda199d	chat_response	gpt-4.1-mini	233	94	327	0.001523	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-12 02:53:51.116513	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
45	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	862	67	929	0.002825	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: Lava turns into rock."}	2025-10-12 02:54:04.224759	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
46	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	789	57	846	0.002543	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 02:54:19.237596	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
47	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2716	165	2881	0.008440	\N	\N	{"fileSize": 282264, "mimeType": "image/jpeg"}	2025-10-12 03:01:13.047436	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
48	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4285	514	4799	0.015853	\N	\N	{"gradeLevel": "5th grade", "problemText": null}	2025-10-12 03:01:22.296218	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
49	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	791	65	856	0.002628	\N	\N	{"gradeLevel": "5th grade", "stepQuestion": "Problem 1: What change of state happens when ice cream melts in the summer?"}	2025-10-12 03:01:24.195608	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
50	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	867	65	932	0.002818	\N	\N	{"gradeLevel": "5th grade", "stepQuestion": "Problem 1: What change of state happens when ice cream melts in the summer?"}	2025-10-12 03:02:06.758188	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
51	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	chat_response	gpt-4.1-mini	239	82	321	0.001418	\N	\N	{"gradeLevel": "5th grade", "messageCount": 1}	2025-10-12 03:02:39.615121	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
52	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	833	45	878	0.002533	\N	\N	{"gradeLevel": "5th grade", "stepQuestion": "Problem 1: What change of state happens when ice cream melts in the summer?"}	2025-10-12 03:02:55.057337	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
53	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	839	72	911	0.002818	\N	\N	{"gradeLevel": "5th grade", "stepQuestion": "Problem 2: What change of state happens when water boils?"}	2025-10-12 03:03:09.261686	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
54	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	791	59	850	0.002568	\N	\N	{"gradeLevel": "5th grade", "stepQuestion": "Problem 1: What change of state happens when ice cream melts in the summer?"}	2025-10-12 03:03:53.140577	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
402	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:08:24.553051	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
412	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:34:00.858054	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
422	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:32:49.493476	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
432	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:57:29.285759	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
433	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	490	5234	0.001006	\N	\N	{"gradeLevel": "9th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:57:39.074945	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
434	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	generate_hint	gpt-4o-mini	781	54	835	0.000150	\N	\N	{"gradeLevel": "9th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-17 20:57:40.90891	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
444	3e3f2acf-0203-4e90-a862-b4d9306c2f45	generate_hint	gpt-4o-mini	857	96	953	0.000186	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: 10 1/4 = _____"}	2025-10-17 21:34:41.494355	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
459	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	857	58	915	0.000163	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: Lava turns into rock."}	2025-10-17 22:11:54.781113	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
472	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	857	64	921	0.000167	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:54:18.280101	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
480	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	37149	30	37179	0.005590	\N	\N	{"fileSize": 92078, "mimeType": "image/jpeg"}	2025-10-18 05:48:35.761253	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
489	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	37149	93	37242	0.005628	\N	\N	{"fileSize": 67991, "mimeType": "image/jpeg"}	2025-10-18 06:04:01.847652	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
490	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	647	5391	0.001100	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 06:04:11.331831	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
491	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	493	5237	0.001007	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 06:04:12.289364	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
403	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	50080	612	50692	0.007879	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:08:40.041027	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
413	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	501	5245	0.001012	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:34:12.346333	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
414	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	generate_hint	gpt-4o-mini	781	54	835	0.000150	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-17 19:34:14.199723	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
423	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	505	5249	0.001015	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:33:00.590457	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
435	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:58:30.620264	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
445	3e3f2acf-0203-4e90-a862-b4d9306c2f45	chat_response	gpt-4o-mini	242	189	431	0.000150	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-17 21:35:14.292574	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
460	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	899	47	946	0.000163	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: Lava turns into rock."}	2025-10-17 22:12:24.154205	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
473	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	823	70	893	0.000165	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:54:50.193718	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
481	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	630	5374	0.001090	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 05:48:46.0753	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
482	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	804	55	859	0.000154	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What state do you live in? Can you circle it on the map?"}	2025-10-18 05:48:47.791308	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
492	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	779	60	839	0.000153	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Simplify √20"}	2025-10-18 06:04:12.596526	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
153	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2561	30	2591	0.006703	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 17:56:26.206594	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
404	b1cfd676-d3dd-4979-9bef-7d79e7c36297	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:10:11.988181	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
415	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:28:41.050409	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
424	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:47:33.95204	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
436	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	506	5250	0.001015	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:58:40.803062	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
437	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	781	48	829	0.000146	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-17 20:58:42.324144	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
446	3e3f2acf-0203-4e90-a862-b4d9306c2f45	chat_response	gpt-4o-mini	241	190	431	0.000150	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-17 21:35:28.053936	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
447	3e3f2acf-0203-4e90-a862-b4d9306c2f45	chat_response	gpt-4o-mini	234	223	457	0.000169	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-17 21:35:36.658615	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
448	3e3f2acf-0203-4e90-a862-b4d9306c2f45	chat_response	gpt-4o-mini	234	303	537	0.000217	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-17 21:35:43.039273	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
461	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	783	44	827	0.000144	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the sun."}	2025-10-17 22:12:54.979199	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
462	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	819	77	896	0.000169	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-17 22:13:01.708683	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
463	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	857	67	924	0.000169	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: Lava turns into rock."}	2025-10-17 22:13:11.039518	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
474	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	823	58	881	0.000158	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:55:14.900989	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
483	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	880	55	935	0.000165	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What state do you live in? Can you circle it on the map?"}	2025-10-18 05:49:02.617541	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
493	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	855	80	935	0.000176	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Simplify √20"}	2025-10-18 06:04:50.341038	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
494	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	821	67	888	0.000163	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Simplify √20"}	2025-10-18 06:04:58.508094	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
495	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	825	64	889	0.000162	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Simplify √24"}	2025-10-18 06:05:08.189941	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
405	b1cfd676-d3dd-4979-9bef-7d79e7c36297	analyze_homework	gpt-4o-mini	50080	612	50692	0.007879	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:10:26.267111	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
416	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	486	5230	0.001003	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:28:51.875809	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
425	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	506	5250	0.001015	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:47:45.326004	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
438	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 21:23:49.6442	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
449	3e3f2acf-0203-4e90-a862-b4d9306c2f45	generate_hint	gpt-4o-mini	803	85	888	0.000171	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: 12 2/5 = _____"}	2025-10-17 21:45:11.237596	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
464	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	37149	111	37260	0.005639	\N	\N	{"fileSize": 67991, "mimeType": "image/jpeg"}	2025-10-18 02:23:46.711844	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
465	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	647	5391	0.001100	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 02:23:56.238913	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
466	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	779	74	853	0.000161	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Simplify √20"}	2025-10-18 02:23:58.030753	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
475	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	825	55	880	0.000157	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: tan x = 1"}	2025-10-18 02:55:33.947793	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
484	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	37149	30	37179	0.005590	\N	\N	{"fileSize": 1585613, "mimeType": "image/jpeg"}	2025-10-18 05:51:44.682016	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
496	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	779	76	855	0.000162	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Simplify √20"}	2025-10-18 06:05:19.544008	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
147	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2561	30	2591	0.006703	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 17:39:24.09756	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
148	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	392	4522	0.014245	\N	\N	{"gradeLevel": "7th grade", "problemText": null}	2025-10-12 17:39:30.862426	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
149	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	802	85	887	0.002855	\N	\N	{"gradeLevel": "7th grade", "stepQuestion": "Problem 1: What is the height of one cup?"}	2025-10-12 17:39:34.187332	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
150	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	850	80	930	0.002925	\N	\N	{"gradeLevel": "7th grade", "stepQuestion": "Problem 1: How many cups are stacked to make 34 cm height?"}	2025-10-12 17:40:02.13286	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
151	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	978	92	1070	0.003365	\N	\N	{"gradeLevel": "7th grade", "stepQuestion": "Problem 1: Calculate the height of one cup using the total height of 5 stacked cups (34 cm) and the height of 2 stacked cups (19 cm)."}	2025-10-12 17:40:10.060273	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
152	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1016	64	1080	0.003180	\N	\N	{"gradeLevel": "7th grade", "stepQuestion": "Problem 1: What is the height of the single cup shown on the right?"}	2025-10-12 17:40:55.588771	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
154	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	520	4650	0.015525	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 17:56:35.439154	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
155	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	796	50	846	0.002490	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup?"}	2025-10-12 17:56:36.730356	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
156	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	918	83	1001	0.003125	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: How do we calculate the height of one cup from the stack of 5 cups measuring 34 cm?"}	2025-10-12 17:56:54.14126	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
157	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	962	94	1056	0.003345	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Calculate the height of one cup using the formula 34 cm ÷ (5 - 1)."}	2025-10-12 17:57:31.482933	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
158	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1050	79	1129	0.003415	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Verify the height of one cup using the stack of 2 cups measuring 19 cm."}	2025-10-12 17:57:39.711974	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
159	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1092	88	1180	0.003610	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Verify the height of one cup using the stack of 2 cups measuring 19 cm."}	2025-10-12 17:57:47.051536	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
160	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1092	82	1174	0.003550	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Verify the height of one cup using the stack of 2 cups measuring 19 cm."}	2025-10-12 17:57:51.328794	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
161	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1104	75	1179	0.003510	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of the single cup shown with a question mark?"}	2025-10-12 17:57:58.053144	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
162	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2561	30	2591	0.006703	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 18:11:00.469838	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
163	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	544	4674	0.015765	\N	\N	{"gradeLevel": "10th grade", "problemText": null}	2025-10-12 18:11:09.539539	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
164	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	802	81	883	0.002815	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 1: What is the height of one cup?"}	2025-10-12 18:11:11.605239	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
165	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	940	73	1013	0.003080	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 1: How do we calculate the height of one cup from the stack of 5 cups measuring 34 cm?"}	2025-10-12 18:11:26.494115	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
166	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	971	90	1061	0.003328	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 1: Calculate the approximate height of one cup by dividing 34 cm by 5."}	2025-10-12 18:11:37.697854	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
167	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1044	156	1200	0.004170	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 2: Given the height of 2 stacked cups is 19 cm, what is the height of one cup?"}	2025-10-12 18:11:43.847353	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
168	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1094	110	1204	0.003835	\N	\N	{"gradeLevel": "10th grade", "stepQuestion": "Problem 3: What is the height of a single cup shown alone with a question mark?"}	2025-10-12 18:11:52.67779	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
169	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2561	124	2685	0.007643	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 18:20:30.502471	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
170	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	498	4628	0.015305	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 18:20:40.004769	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
171	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	476	4606	0.015085	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 18:20:40.986786	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
172	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	802	68	870	0.002685	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup?"}	2025-10-12 18:20:42.475349	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
173	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	845	93	938	0.000183	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: How many cups are stacked to reach 34 cm?"}	2025-10-12 18:20:59.027515	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
174	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	952	90	1042	0.000197	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: How do we calculate the height of one cup using the total height of 5 stacked cups?"}	2025-10-12 18:21:05.775755	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
175	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1004	71	1075	0.000193	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 2 stacked cups measure 19 cm?"}	2025-10-12 18:21:22.441967	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
176	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1046	106	1152	0.000221	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 2 stacked cups measure 19 cm?"}	2025-10-12 18:21:29.365751	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
177	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1046	106	1152	0.000221	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 2 stacked cups measure 19 cm?"}	2025-10-12 18:22:34.549001	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
178	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1046	105	1151	0.000220	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 2 stacked cups measure 19 cm?"}	2025-10-12 18:23:12.14163	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
179	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1046	115	1161	0.000226	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 2 stacked cups measure 19 cm?"}	2025-10-12 18:23:18.029007	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
180	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1058	87	1145	0.000211	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of the single cup shown with a question mark?"}	2025-10-12 18:23:29.691336	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
181	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4o-mini	25815	30	25845	0.003890	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 18:31:56.054326	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
182	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4o-mini	27267	487	27754	0.004382	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 18:32:13.149849	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
183	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	822	79	901	0.000171	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:32:18.357802	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
184	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	864	71	935	0.000172	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:32:55.538095	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
185	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	864	82	946	0.000179	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:33:00.427258	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
186	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	864	89	953	0.000183	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:33:05.116477	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
187	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	864	87	951	0.000182	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:33:11.023603	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
188	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	864	129	993	0.000207	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stacked together measure 34 cm?"}	2025-10-12 18:33:52.863683	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
189	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	chat_response	gpt-4o-mini	1840	309	2149	0.000461	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-12 18:34:11.685769	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
190	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	880	111	991	0.000199	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Calculate the height of one cup using the equation 5h = 34 cm."}	2025-10-12 18:35:46.799738	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
191	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	968	85	1053	0.000196	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What is the height of 2 cups stacked together if they measure 19 cm?"}	2025-10-12 18:35:53.762553	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
192	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1018	81	1099	0.000201	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Calculate the height of one cup using the equation 2h = 19 cm."}	2025-10-12 18:36:00.367784	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
193	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	1090	60	1150	0.000200	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: If we know the height of one cup, how can we find the height of 3 cups?"}	2025-10-12 18:36:08.939726	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
194	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	chat_response	gpt-4o-mini	1829	181	2010	0.000383	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-12 18:36:50.651663	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
195	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4o-mini	25815	30	25845	0.003890	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 18:41:12.722043	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
196	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4o-mini	27267	529	27796	0.004407	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 18:41:24.277505	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
197	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o-mini	826	87	913	0.000176	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the height of one cup if 5 cups stack to 34 cm?"}	2025-10-12 18:41:28.496729	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
198	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	906	92	998	0.003185	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: How do we calculate the height of one cup?"}	2025-10-12 18:41:51.89692	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
199	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	948	127	1075	0.003640	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: How do we calculate the height of one cup?"}	2025-10-12 18:42:17.091865	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
200	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	944	78	1022	0.003140	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What is the height of 2 cups if they stack to 19 cm?"}	2025-10-12 18:42:24.187114	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
201	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	1046	77	1123	0.003385	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: How do we calculate the height of one cup from 2 cups?"}	2025-10-12 18:42:30.013041	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
202	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	1070	116	1186	0.003835	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: What is the height of one cup based on the previous calculations?"}	2025-10-12 18:42:38.748363	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
203	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	1112	149	1261	0.004270	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: What is the height of one cup based on the previous calculations?"}	2025-10-12 18:42:44.875087	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
204	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	1112	131	1243	0.004090	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: What is the height of one cup based on the previous calculations?"}	2025-10-12 18:47:09.301138	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
205	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4o	1419	30	1449	0.003848	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-12 18:48:28.324472	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
206	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4o	2639	345	2984	0.010048	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 18:48:39.324404	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
207	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	788	56	844	0.002530	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What change of state occurs when ice cream melts in the summer?"}	2025-10-12 18:48:40.900192	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
208	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	830	73	903	0.002805	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What change of state occurs when ice cream melts in the summer?"}	2025-10-12 18:48:44.745233	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
209	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4o	837	71	908	0.002803	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What change of state occurs when water boils?"}	2025-10-12 18:48:50.172447	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
210	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4o-mini	25815	30	25845	0.003890	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 19:21:40.533347	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
211	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	validate_image	gpt-4.1-mini	2561	30	2591	0.006703	\N	\N	{"fileSize": 124361, "mimeType": "image/jpeg"}	2025-10-12 19:22:54.969626	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
212	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	analyze_homework	gpt-4.1-mini	4130	507	4637	0.015395	\N	\N	{"gradeLevel": "College - Freshman", "problemText": null}	2025-10-12 19:23:02.765576	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
213	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	798	79	877	0.002785	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: What is the height of one cup?"}	2025-10-12 19:23:04.872653	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
214	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	843	97	940	0.003078	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: How many cups are stacked to reach 34 cm?"}	2025-10-12 19:23:09.991761	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
215	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	942	83	1025	0.003185	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: How to calculate the height of one cup from the stack of 5 cups measuring 34 cm?"}	2025-10-12 19:23:15.67796	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
216	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	982	97	1079	0.003425	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: Calculate the height of one cup using 34 ÷ 5."}	2025-10-12 19:23:22.685662	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
217	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1062	102	1164	0.003675	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: Verify the height of the cup using the stack of 2 cups measuring 19 cm."}	2025-10-12 19:23:27.287718	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
218	a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	generate_hint	gpt-4.1-mini	1104	67	1171	0.003430	\N	\N	{"gradeLevel": "College - Freshman", "stepQuestion": "Problem 1: Verify the height of the cup using the stack of 2 cups measuring 19 cm."}	2025-10-12 19:23:31.743557	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
219	d4050ff7-da76-4a37-a1f6-585bbeda199d	validate_image	gpt-4.1-mini	2153	112	2265	0.006503	\N	\N	{"fileSize": 94987, "mimeType": "image/jpeg"}	2025-10-12 19:36:53.699423	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
220	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	3722	576	4298	0.015065	\N	\N	{"gradeLevel": "9th grade", "problemText": null}	2025-10-12 19:37:03.44354	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
221	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	3722	555	4277	0.014855	\N	\N	{"gradeLevel": "9th grade", "problemText": null}	2025-10-12 19:37:04.59465	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
222	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	808	71	879	0.002730	\N	\N	{"gradeLevel": "9th grade", "stepQuestion": "Problem 1: Classify the change of state for 'Ice cream in ___ the summer.'"}	2025-10-12 19:37:05.387018	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
223	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	855	62	917	0.002758	\N	\N	{"gradeLevel": "9th grade", "stepQuestion": "Problem 2: Classify the change of state for water boiling."}	2025-10-12 19:37:11.501453	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
224	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	931	59	990	0.002918	\N	\N	{"gradeLevel": "9th grade", "stepQuestion": "Problem 2: Classify the change of state for water boiling."}	2025-10-12 19:37:15.945952	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
225	d4050ff7-da76-4a37-a1f6-585bbeda199d	validate_image	gpt-4.1-mini	2289	30	2319	0.006023	\N	\N	{"fileSize": 108662, "mimeType": "image/jpeg"}	2025-10-12 19:43:31.844249	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
226	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	3858	64	3922	0.010285	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 19:43:35.40026	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
227	d4050ff7-da76-4a37-a1f6-585bbeda199d	validate_image	gpt-4.1-mini	2765	180	2945	0.008713	\N	\N	{"fileSize": 257309, "mimeType": "image/jpeg"}	2025-10-12 19:44:06.494529	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
228	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	4334	534	4868	0.016175	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 19:44:14.905919	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
229	d4050ff7-da76-4a37-a1f6-585bbeda199d	generate_hint	gpt-4.1-mini	800	56	856	0.002560	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Classifying Changes of State - Ice cream in the summer."}	2025-10-12 19:44:16.678359	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
230	d4050ff7-da76-4a37-a1f6-585bbeda199d	analyze_homework	gpt-4.1-mini	4334	570	4904	0.016535	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 19:44:21.787669	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
231	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2153	130	2283	0.006683	\N	\N	{"fileSize": 94987, "mimeType": "image/jpeg"}	2025-10-12 20:01:56.101186	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
232	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	3722	515	4237	0.014455	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 20:02:03.077705	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
233	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	786	49	835	0.002455	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 20:02:04.505774	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
234	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	3722	518	4240	0.014485	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 20:02:10.120691	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
235	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	1934	30	1964	0.005135	\N	\N	{"fileSize": 88716, "mimeType": "image/jpeg"}	2025-10-12 20:11:08.035176	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
236	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	3503	343	3846	0.012188	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 20:11:13.887255	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
237	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	787	52	839	0.002488	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the summer."}	2025-10-12 20:11:15.258885	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
238	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2752	113	2865	0.008010	\N	\N	{"fileSize": 1348623, "mimeType": "image/jpeg"}	2025-10-12 20:12:33.944595	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
239	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	4321	363	4684	0.014433	\N	\N	{"gradeLevel": "4th grade", "problemText": null}	2025-10-12 20:12:44.447066	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
240	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	789	76	865	0.002733	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 356 divided by 5?"}	2025-10-12 20:12:46.038097	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
241	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2801	125	2926	0.008253	\N	\N	{"fileSize": 824067, "mimeType": "image/jpeg"}	2025-10-12 20:14:38.349215	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
242	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	4398	393	4791	0.014925	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-12 20:14:46.864517	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
243	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	788	88	876	0.002850	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 356 multiplied by 5?"}	2025-10-12 20:14:49.034032	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
244	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	7151	636	7787	0.024238	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": true}	2025-10-12 20:14:50.992865	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
245	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	895	51	946	0.002748	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the first step in multiplying 356 by 5?"}	2025-10-12 20:15:22.350821	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
246	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	947	79	1026	0.003158	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What do we do with the 30 from the first step?"}	2025-10-12 20:15:52.921012	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
247	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	989	79	1068	0.003263	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What do we do with the 30 from the first step?"}	2025-10-12 20:16:32.051812	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
248	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1016	81	1097	0.003350	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the next multiplication step?"}	2025-10-12 20:16:38.724711	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
249	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1058	107	1165	0.003715	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the next multiplication step?"}	2025-10-12 20:17:51.797983	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
250	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1085	64	1149	0.003353	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the final step to complete the multiplication?"}	2025-10-12 20:18:06.590008	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
251	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1112	61	1173	0.003390	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the final answer to 356 x 5?"}	2025-10-12 20:18:42.149806	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
252	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2752	123	2875	0.008110	\N	\N	{"fileSize": 1427222, "mimeType": "image/jpeg"}	2025-10-12 20:22:29.203796	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
253	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	4349	511	4860	0.015983	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-12 20:22:41.361015	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
254	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	7102	592	7694	0.023675	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": true}	2025-10-12 20:22:41.690827	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
255	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	788	82	870	0.002790	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 356 multiplied by 5?"}	2025-10-12 20:22:43.626537	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
256	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	883	66	949	0.002868	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the first step in multiplying 356 by 5?"}	2025-10-12 20:23:02.704797	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
257	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	935	80	1015	0.003138	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What do we do with the 30 from the first multiplication?"}	2025-10-12 20:23:23.360519	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
258	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1007	69	1076	0.003208	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the tens digit (5) by 5 and add the carry 3."}	2025-10-12 20:24:05.347357	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
259	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1049	86	1135	0.003483	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the tens digit (5) by 5 and add the carry 3."}	2025-10-12 20:24:11.713275	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
260	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1049	78	1127	0.003403	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the tens digit (5) by 5 and add the carry 3."}	2025-10-12 20:24:22.721391	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
261	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1045	61	1106	0.003223	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the hundreds digit (3) by 5 and add the carry if any."}	2025-10-12 20:24:31.480183	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
262	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	1108	108	1216	0.003850	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the final answer for 356 × 5?"}	2025-10-12 20:25:50.701783	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
263	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2801	30	2831	0.007303	\N	\N	{"fileSize": 983646, "mimeType": "image/jpeg"}	2025-10-12 20:28:22.289195	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
264	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	7151	525	7676	0.023128	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": true}	2025-10-12 20:28:34.435553	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
265	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	810	52	862	0.002545	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is the multiplication problem shown?"}	2025-10-12 20:28:36.394175	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
266	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2752	30	2782	0.007180	\N	\N	{"fileSize": 1460159, "mimeType": "image/jpeg"}	2025-10-12 20:29:48.369239	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
267	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	7018	369	7387	0.021235	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": true}	2025-10-12 20:30:00.124912	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
268	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	790	67	857	0.002645	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply 386 by 2"}	2025-10-12 20:30:01.619901	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
269	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	866	61	927	0.002775	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply 386 by 2"}	2025-10-12 20:30:33.328858	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
270	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	832	76	908	0.002840	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply 386 by 2"}	2025-10-12 20:30:54.640361	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
271	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	827	47	874	0.002538	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the ones place digit"}	2025-10-12 20:31:11.653217	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
272	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	871	102	973	0.003198	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the tens place digit"}	2025-10-12 20:31:31.34943	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
273	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	909	93	1002	0.003203	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the hundreds place digit"}	2025-10-12 20:31:43.702587	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
274	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	951	86	1037	0.003238	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply the hundreds place digit"}	2025-10-12 20:31:52.218917	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
275	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	940	83	1023	0.003180	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Add all partial products"}	2025-10-12 20:32:01.422048	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
276	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	validate_image	gpt-4.1-mini	2624	30	2654	0.006860	\N	\N	{"fileSize": 999003, "mimeType": "image/jpeg"}	2025-10-12 21:10:26.250482	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
277	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	analyze_homework	gpt-4.1-mini	4221	1159	5380	0.022143	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-12 21:10:53.876709	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
278	8cbe43e9-be23-4c9a-8b0f-de13f05432b9	generate_hint	gpt-4.1-mini	798	75	873	0.002745	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Determine the area of the rectangle."}	2025-10-12 21:10:55.632973	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
279	82c463e3-8349-4657-96a1-99ef136c9163	validate_image	gpt-4.1-mini	2668	30	2698	0.006970	\N	\N	{"fileSize": 3567833, "mimeType": "image/jpeg"}	2025-10-13 01:08:14.88113	1CA248AE-2252-4F35-9C7B-310490274514
280	82c463e3-8349-4657-96a1-99ef136c9163	analyze_homework	gpt-4.1-mini	4265	1255	5520	0.023213	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-13 01:08:42.706576	1CA248AE-2252-4F35-9C7B-310490274514
281	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	834	68	902	0.002765	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blanks for multiplication and division equations"}	2025-10-13 01:08:44.801507	1CA248AE-2252-4F35-9C7B-310490274514
282	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	910	86	996	0.003135	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blanks for multiplication and division equations"}	2025-10-13 01:09:38.840015	1CA248AE-2252-4F35-9C7B-310490274514
283	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	855	82	937	0.002958	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What number multiplied by 7 equals 700?"}	2025-10-13 01:10:44.666649	1CA248AE-2252-4F35-9C7B-310490274514
284	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	931	70	1001	0.003028	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What number multiplied by 7 equals 700?"}	2025-10-13 01:11:15.413761	1CA248AE-2252-4F35-9C7B-310490274514
285	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	925	109	1034	0.003403	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: 7,000 = _____ x 1,000"}	2025-10-13 01:11:34.093212	1CA248AE-2252-4F35-9C7B-310490274514
286	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	961	64	1025	0.003043	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: 10 x 6 = _____"}	2025-10-13 01:12:50.463531	1CA248AE-2252-4F35-9C7B-310490274514
287	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1025	101	1126	0.003573	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: _____ x 50 = 5,000"}	2025-10-13 01:13:22.675354	1CA248AE-2252-4F35-9C7B-310490274514
288	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1101	75	1176	0.003503	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: _____ x 50 = 5,000"}	2025-10-13 01:15:46.921969	1CA248AE-2252-4F35-9C7B-310490274514
289	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1106	78	1184	0.003545	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blanks for multiplication equations"}	2025-10-13 01:16:44.066047	1CA248AE-2252-4F35-9C7B-310490274514
290	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1129	57	1186	0.003393	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 100 x 17 = _____"}	2025-10-13 01:17:44.343284	1CA248AE-2252-4F35-9C7B-310490274514
291	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1171	77	1248	0.003698	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 100 x 17 = _____"}	2025-10-13 01:19:17.359491	1CA248AE-2252-4F35-9C7B-310490274514
292	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1183	49	1232	0.003448	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: _____ = 10 x 43"}	2025-10-13 01:19:46.251369	1CA248AE-2252-4F35-9C7B-310490274514
293	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1256	77	1333	0.003910	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 87,000 = _____ x 1,000"}	2025-10-13 01:20:14.141797	1CA248AE-2252-4F35-9C7B-310490274514
294	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1295	58	1353	0.003818	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 400 = 4 x _____"}	2025-10-13 01:20:40.919692	1CA248AE-2252-4F35-9C7B-310490274514
295	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1401	79	1480	0.004293	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: Birdie ran 4 hours each day for 30 days. How many hours did Birdie run altogether? Fill in the blank: Birdie ran for _____ hours altogether."}	2025-10-13 01:21:08.355715	1CA248AE-2252-4F35-9C7B-310490274514
296	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1484	85	1569	0.004560	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 4: Use unit form (tens, hundreds, thousands) to complete the equation: 3 x 4,000 = 12 _____"}	2025-10-13 01:21:46.263776	1CA248AE-2252-4F35-9C7B-310490274514
297	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1539	63	1602	0.004478	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 4: Fill in the blank: 3 times _____ is 12 thousands."}	2025-10-13 01:22:13.74905	1CA248AE-2252-4F35-9C7B-310490274514
298	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1587	88	1675	0.004848	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 4: Fill in the blank: 500 is 5 times _____"}	2025-10-13 01:22:37.782357	1CA248AE-2252-4F35-9C7B-310490274514
299	82c463e3-8349-4657-96a1-99ef136c9163	validate_image	gpt-4.1-mini	2668	30	2698	0.006970	\N	\N	{"fileSize": 3515415, "mimeType": "image/jpeg"}	2025-10-13 01:39:23.543496	1CA248AE-2252-4F35-9C7B-310490274514
300	82c463e3-8349-4657-96a1-99ef136c9163	analyze_homework	gpt-4.1-mini	4265	1334	5599	0.024003	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-13 01:39:53.084782	1CA248AE-2252-4F35-9C7B-310490274514
301	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	810	70	880	0.002725	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blanks for multiplication facts"}	2025-10-13 01:39:55.098597	1CA248AE-2252-4F35-9C7B-310490274514
302	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	852	73	925	0.002860	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blanks for multiplication facts"}	2025-10-13 01:40:19.855035	1CA248AE-2252-4F35-9C7B-310490274514
303	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	886	70	956	0.002915	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blanks for multiplication facts"}	2025-10-13 01:40:31.057122	1CA248AE-2252-4F35-9C7B-310490274514
304	82c463e3-8349-4657-96a1-99ef136c9163	chat_response	gpt-4.1-mini	246	87	333	0.001485	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-13 01:40:51.173027	1CA248AE-2252-4F35-9C7B-310490274514
305	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	849	64	913	0.002763	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What number times 7 equals 700?"}	2025-10-13 01:41:17.640897	1CA248AE-2252-4F35-9C7B-310490274514
306	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	925	69	994	0.003003	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What number times 7 equals 700?"}	2025-10-13 01:41:45.561191	1CA248AE-2252-4F35-9C7B-310490274514
307	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	918	99	1017	0.003285	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: 7,000 = ___ x 1,000"}	2025-10-13 01:41:55.003863	1CA248AE-2252-4F35-9C7B-310490274514
308	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	953	68	1021	0.003063	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: 10 x 6 = ___"}	2025-10-13 01:42:25.582653	1CA248AE-2252-4F35-9C7B-310490274514
309	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	995	73	1068	0.003218	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: 10 x 6 = ___"}	2025-10-13 01:42:40.215796	1CA248AE-2252-4F35-9C7B-310490274514
310	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1015	108	1123	0.003618	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: ___ x 50 = 5,000"}	2025-10-13 01:42:50.390223	1CA248AE-2252-4F35-9C7B-310490274514
311	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1057	170	1227	0.004343	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Fill in the blank: ___ x 50 = 5,000"}	2025-10-13 01:43:46.819391	1CA248AE-2252-4F35-9C7B-310490274514
312	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1074	122	1196	0.003905	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 4,000 = 10 x ___"}	2025-10-13 01:45:21.198148	1CA248AE-2252-4F35-9C7B-310490274514
313	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1125	52	1177	0.003333	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 100 x 17 = ___"}	2025-10-13 01:46:27.220296	1CA248AE-2252-4F35-9C7B-310490274514
314	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1176	51	1227	0.003450	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: ___ = 10 x 43"}	2025-10-13 01:47:00.806179	1CA248AE-2252-4F35-9C7B-310490274514
315	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1218	63	1281	0.003675	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: ___ = 10 x 43"}	2025-10-13 01:47:14.577016	1CA248AE-2252-4F35-9C7B-310490274514
316	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1246	80	1326	0.003915	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 87,000 = ___ x 1,000"}	2025-10-13 01:47:23.314063	1CA248AE-2252-4F35-9C7B-310490274514
317	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1288	72	1360	0.003940	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 87,000 = ___ x 1,000"}	2025-10-13 01:47:31.784363	1CA248AE-2252-4F35-9C7B-310490274514
318	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1288	76	1364	0.003980	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 87,000 = ___ x 1,000"}	2025-10-13 01:47:42.280159	1CA248AE-2252-4F35-9C7B-310490274514
319	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1287	72	1359	0.003938	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Fill in the blank: 400 = 4 x ___"}	2025-10-13 01:47:48.814353	1CA248AE-2252-4F35-9C7B-310490274514
406	b1cfd676-d3dd-4979-9bef-7d79e7c36297	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:11:40.350086	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
417	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	37149	107	37256	0.005637	\N	\N	{"fileSize": 133347, "mimeType": "image/jpeg"}	2025-10-17 20:29:09.755657	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
418	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	261	5005	0.000868	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:29:16.135457	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
419	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	261	5005	0.000868	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:29:17.030409	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
426	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:49:40.617287	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
427	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	490	5234	0.001006	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:49:48.837091	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
439	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	489	5233	0.001005	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 21:23:59.750907	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
440	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	781	82	863	0.000166	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-17 21:24:03.187465	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
450	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	825	42	867	0.000149	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: tan x = 1"}	2025-10-17 22:09:55.841648	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
467	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	825	61	886	0.000160	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Simplify √24"}	2025-10-18 02:24:29.361001	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
476	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-18 02:55:46.414688	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
477	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	500	5244	0.001012	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 02:55:52.989735	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
407	b1cfd676-d3dd-4979-9bef-7d79e7c36297	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 19:21:30.405965	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
420	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:30:22.102055	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
428	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	14481	30	14511	0.002190	\N	\N	{"fileSize": 87550, "mimeType": "image/jpeg"}	2025-10-17 20:52:07.020321	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
429	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	419	5163	0.000963	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:52:15.333162	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
441	3e3f2acf-0203-4e90-a862-b4d9306c2f45	validate_image	gpt-4o-mini	37149	30	37179	0.005590	\N	\N	{"fileSize": 93095, "mimeType": "image/jpeg"}	2025-10-17 21:33:11.059967	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
451	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 282264, "mimeType": "image/jpeg"}	2025-10-17 22:10:34.289158	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
452	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	499	5243	0.001011	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 22:10:43.803417	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
453	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	783	47	830	0.000146	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the sun."}	2025-10-17 22:10:46.485717	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
468	85453e87-deff-41d6-9e32-d3fc38eee454	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-18 02:52:29.638202	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
469	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	505	5249	0.001015	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 02:52:37.499163	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
470	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	781	42	823	0.000142	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:52:38.906967	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
478	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	781	52	833	0.000148	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:55:54.046299	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
343	82c463e3-8349-4657-96a1-99ef136c9163	validate_image	gpt-4.1-mini	2716	160	2876	0.008390	\N	\N	{"fileSize": 280097, "mimeType": "image/jpeg"}	2025-10-13 18:15:05.26001	1CA248AE-2252-4F35-9C7B-310490274514
344	82c463e3-8349-4657-96a1-99ef136c9163	analyze_homework	gpt-4.1-mini	4313	513	4826	0.015913	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-13 18:15:14.035349	1CA248AE-2252-4F35-9C7B-310490274514
345	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	789	60	849	0.002573	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What change of state happens to ice cream in the summer?"}	2025-10-13 18:15:15.522498	1CA248AE-2252-4F35-9C7B-310490274514
346	82c463e3-8349-4657-96a1-99ef136c9163	analyze_homework	gpt-4.1-mini	4313	515	4828	0.015933	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-13 18:15:16.886696	1CA248AE-2252-4F35-9C7B-310490274514
347	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	865	58	923	0.002743	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What change of state happens to ice cream in the summer?"}	2025-10-13 18:15:35.779207	1CA248AE-2252-4F35-9C7B-310490274514
348	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	839	71	910	0.002808	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What change of state happens when water boils?"}	2025-10-13 18:15:50.768751	1CA248AE-2252-4F35-9C7B-310490274514
349	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	915	57	972	0.002858	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What change of state happens when water boils?"}	2025-10-13 18:16:29.686941	1CA248AE-2252-4F35-9C7B-310490274514
350	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	888	78	966	0.003000	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 3: What change of state happens when lava turns into rock?"}	2025-10-13 18:16:53.65815	1CA248AE-2252-4F35-9C7B-310490274514
351	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	931	69	1000	0.003018	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 4: What change of state happens when clothes dry?"}	2025-10-13 18:17:19.307749	1CA248AE-2252-4F35-9C7B-310490274514
352	82c463e3-8349-4657-96a1-99ef136c9163	chat_response	gpt-4.1-mini	234	90	324	0.001485	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-13 18:19:44.448252	1CA248AE-2252-4F35-9C7B-310490274514
353	82c463e3-8349-4657-96a1-99ef136c9163	chat_response	gpt-4.1-mini	234	79	313	0.001375	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-13 18:19:46.822122	1CA248AE-2252-4F35-9C7B-310490274514
354	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	973	75	1048	0.003183	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 4: What change of state happens when clothes dry?"}	2025-10-13 18:20:06.536159	1CA248AE-2252-4F35-9C7B-310490274514
355	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	985	59	1044	0.003053	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 5: What change of state happens during the creation of clouds?"}	2025-10-13 18:20:22.022299	1CA248AE-2252-4F35-9C7B-310490274514
356	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4.1-mini	1023	55	1078	0.003108	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 6: What change of state happens when steel is fused?"}	2025-10-13 18:20:48.885935	1CA248AE-2252-4F35-9C7B-310490274514
485	85453e87-deff-41d6-9e32-d3fc38eee454	analyze_homework	gpt-4o-mini	4744	961	5705	0.001288	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-18 05:52:01.099654	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
486	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	801	62	863	0.000157	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Determine the area of the rectangle."}	2025-10-18 05:52:02.887267	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
390	82c463e3-8349-4657-96a1-99ef136c9163	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 1044994, "mimeType": "image/jpeg"}	2025-10-14 04:22:53.130772	1CA248AE-2252-4F35-9C7B-310490274514
391	82c463e3-8349-4657-96a1-99ef136c9163	analyze_homework	gpt-4o-mini	4221	570	4791	0.000975	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-14 04:23:03.700795	1CA248AE-2252-4F35-9C7B-310490274514
392	82c463e3-8349-4657-96a1-99ef136c9163	generate_hint	gpt-4o-mini	805	80	885	0.000169	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Multiply 251 by 3 using partial products"}	2025-10-14 04:23:06.240937	1CA248AE-2252-4F35-9C7B-310490274514
393	8511b345-0d92-4c84-95a2-9d3483c8829e	validate_image	gpt-4o-mini	48483	71	48554	0.007315	\N	\N	{"fileSize": 1332360, "mimeType": "image/jpeg"}	2025-10-14 21:26:58.360698	FDA2BCA6-6C1A-4681-99BC-450713EDC958
394	8511b345-0d92-4c84-95a2-9d3483c8829e	analyze_homework	gpt-4o-mini	4398	1096	5494	0.001317	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-14 21:27:17.682687	FDA2BCA6-6C1A-4681-99BC-450713EDC958
395	8511b345-0d92-4c84-95a2-9d3483c8829e	generate_hint	gpt-4o-mini	781	46	827	0.000145	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 4 + 3?"}	2025-10-14 21:27:19.634673	FDA2BCA6-6C1A-4681-99BC-450713EDC958
396	8511b345-0d92-4c84-95a2-9d3483c8829e	analyze_homework	gpt-4o-mini	4398	1066	5464	0.001299	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-14 21:27:23.029689	FDA2BCA6-6C1A-4681-99BC-450713EDC958
397	8511b345-0d92-4c84-95a2-9d3483c8829e	generate_hint	gpt-4o-mini	853	48	901	0.000157	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 4 + 3?"}	2025-10-14 21:28:13.142264	FDA2BCA6-6C1A-4681-99BC-450713EDC958
398	8511b345-0d92-4c84-95a2-9d3483c8829e	generate_hint	gpt-4o-mini	853	47	900	0.000156	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: What is 4 + 3?"}	2025-10-14 21:28:29.632952	FDA2BCA6-6C1A-4681-99BC-450713EDC958
399	8511b345-0d92-4c84-95a2-9d3483c8829e	generate_hint	gpt-4o-mini	827	58	885	0.000159	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What is 8 + 2?"}	2025-10-14 21:28:45.045837	FDA2BCA6-6C1A-4681-99BC-450713EDC958
400	8511b345-0d92-4c84-95a2-9d3483c8829e	generate_hint	gpt-4o-mini	869	67	936	0.000171	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: What is 8 + 2?"}	2025-10-14 21:28:51.238022	FDA2BCA6-6C1A-4681-99BC-450713EDC958
408	b1cfd676-d3dd-4979-9bef-7d79e7c36297	analyze_homework	gpt-4o-mini	4744	489	5233	0.001005	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 19:21:51.020592	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
421	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	505	5249	0.001015	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:30:33.182747	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
430	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	validate_image	gpt-4o-mini	48483	30	48513	0.007290	\N	\N	{"fileSize": 95529, "mimeType": "image/jpeg"}	2025-10-17 20:53:30.722319	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
431	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	analyze_homework	gpt-4o-mini	4744	490	5234	0.001006	\N	\N	{"gradeLevel": "9th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 20:53:40.654294	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
442	3e3f2acf-0203-4e90-a862-b4d9306c2f45	analyze_homework	gpt-4o-mini	4744	1194	5938	0.001428	\N	\N	{"gradeLevel": "4th grade", "problemText": null, "hasTeacherMethod": false}	2025-10-17 21:33:32.35682	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
443	3e3f2acf-0203-4e90-a862-b4d9306c2f45	generate_hint	gpt-4o-mini	803	98	901	0.000179	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: 12 2/5 = _____"}	2025-10-17 21:33:34.759187	32E10282-BB25-4566-BEFB-5F5CEDECF8FD
454	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	783	50	833	0.000147	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Ice cream in the sun."}	2025-10-17 22:11:20.662067	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
455	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	819	67	886	0.000163	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-17 22:11:25.534577	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
456	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	861	66	927	0.000169	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-17 22:11:28.600478	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
457	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	895	64	959	0.000173	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-17 22:11:33.861711	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
458	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	861	66	927	0.000169	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 2: Water boiling."}	2025-10-17 22:11:38.552087	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
471	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	857	56	913	0.000162	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: sin x = 1"}	2025-10-18 02:53:06.313018	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
479	85453e87-deff-41d6-9e32-d3fc38eee454	chat_response	gpt-4o-mini	239	208	447	0.000161	\N	\N	{"gradeLevel": "4th grade", "messageCount": 1}	2025-10-18 02:56:10.153322	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
487	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	843	64	907	0.000165	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Determine the area of the rectangle."}	2025-10-18 05:52:42.310535	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
488	85453e87-deff-41d6-9e32-d3fc38eee454	generate_hint	gpt-4o-mini	877	109	986	0.000197	\N	\N	{"gradeLevel": "4th grade", "stepQuestion": "Problem 1: Determine the area of the rectangle."}	2025-10-18 05:52:51.359124	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86
\.


--
-- TOC entry 4355 (class 0 OID 25028)
-- Dependencies: 233
-- Data for Name: user_devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_devices (user_id, device_id, device_name, is_trusted, first_seen, last_seen, login_count) FROM stdin;
ba57e63c-23bb-44d0-99a7-052c309b5b2b	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-15 02:58:18.442311	2025-10-15 02:58:18.442311	1
96bca4a5-cca8-4855-a41e-932b741d57c3	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-16 22:19:31.972198	2025-10-16 22:19:31.972198	1
a55de8e9-ebb9-4fad-bd2d-4596f4a520cf	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-11 20:22:27.204824	2025-10-12 21:13:03.737499	11
d4050ff7-da76-4a37-a1f6-585bbeda199d	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-12 01:25:42.48248	2025-10-12 21:34:21.728791	5
33bc2695-7dcf-4109-bb70-ffc6fcb958a8	test-device	Test iPhone	f	2025-10-09 21:27:51.761788	2025-10-09 21:27:51.761788	1
f430a463-c285-4ab3-a8d5-7fd38f0c5f85	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-12 21:44:41.727768	2025-10-12 21:44:41.727768	1
610b14cb-c446-46b7-bcac-e0565e7ea5ea	test-device-123	Test iPhone	f	2025-10-09 21:28:03.203615	2025-10-09 21:28:03.203615	1
8cbe43e9-be23-4c9a-8b0f-de13f05432b9	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-11 20:23:06.797317	2025-10-12 21:48:49.80738	7
8ca1bd33-89e6-4508-92df-872fc8450ef4	unknown	Unknown Device	f	2025-10-09 21:28:57.623161	2025-10-09 21:28:57.623161	1
3797d874-5599-4844-8d6d-e1958e11d82a	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	iPhone	f	2025-10-09 21:02:47.784029	2025-10-09 22:34:59.045263	8
c21dc002-5828-4cd6-b414-4ef55a6d8e31	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-12 23:55:48.308435	2025-10-16 22:23:09.226616	6
fc06e3c3-d68e-42aa-b584-b0a59ae8c718	unknown	Unknown Device	f	2025-10-10 17:35:11.05238	2025-10-10 17:35:11.05238	1
81ec2385-7f7f-4db8-89b9-204d0c24a1df	unknown	Unknown Device	f	2025-10-10 17:15:26.515462	2025-10-10 17:52:42.940344	2
f30fe78c-277e-432e-a1f6-83c4fad36837	16B4EB1B-D2BA-4E7A-A40F-CF01B1C6AE1C	iPhone	f	2025-10-09 21:02:08.797217	2025-10-10 17:56:03.956936	12
f30fe78c-277e-432e-a1f6-83c4fad36837	unknown	Unknown Device	f	2025-10-10 19:12:25.293608	2025-10-10 19:12:25.293608	1
3797d874-5599-4844-8d6d-e1958e11d82a	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	iPhone	f	2025-10-11 00:12:45.47581	2025-10-11 00:12:45.47581	1
f30fe78c-277e-432e-a1f6-83c4fad36837	5C075B04-25B8-4915-A49A-0E1EF0E5C6B3	iPhone	f	2025-10-10 23:38:35.595732	2025-10-11 00:48:36.276807	2
3797d874-5599-4844-8d6d-e1958e11d82a	AC10B57F-4137-4F20-9C76-A7C9540F387E	iPhone	f	2025-10-11 03:32:05.436178	2025-10-11 03:32:05.436178	1
f30fe78c-277e-432e-a1f6-83c4fad36837	7475847D-E5AC-4675-84BC-28BECB336E35	iPhone	f	2025-10-11 04:09:19.843967	2025-10-11 04:09:19.843967	1
3797d874-5599-4844-8d6d-e1958e11d82a	1EC2C674-60A2-42C5-8D8E-760561CFDD32	iPhone	f	2025-10-11 04:13:05.014639	2025-10-11 04:13:05.014639	1
3797d874-5599-4844-8d6d-e1958e11d82a	196A465D-D76E-4029-8835-4CCCCCD38612	iPhone	f	2025-10-11 17:42:59.540143	2025-10-11 17:42:59.540143	1
f30fe78c-277e-432e-a1f6-83c4fad36837	F877F805-6C36-4648-8024-A739638B1DFE	iPhone	f	2025-10-11 04:24:21.735838	2025-10-11 19:21:54.570435	2
b1cfd676-d3dd-4979-9bef-7d79e7c36297	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-15 03:05:51.453636	2025-10-17 19:09:51.46504	2
82c463e3-8349-4657-96a1-99ef136c9163	1CA248AE-2252-4F35-9C7B-310490274514	iPhone	f	2025-10-14 04:25:04.790596	2025-10-14 04:25:04.790596	1
71cc27f6-5272-435c-a326-5853af953e77	7128365C-CB0B-4430-9333-6AA2CD7F5C1A	iPad	f	2025-10-14 17:47:21.730176	2025-10-14 17:47:21.730176	1
f1ba3a5e-b20d-410d-add0-1aefcf5717e5	unknown	Unknown Device	f	2025-10-17 20:15:29.480534	2025-10-17 20:15:29.480534	1
8cbe43e9-be23-4c9a-8b0f-de13f05432b9	196A465D-D76E-4029-8835-4CCCCCD38612	iPhone	f	2025-10-11 23:46:53.727892	2025-10-11 23:46:53.727892	1
db27c446-cab9-40dc-b5a3-1b9863c8437f	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-11 21:56:41.195877	2025-10-12 01:23:22.04193	2
33bc2695-7dcf-4109-bb70-ffc6fcb958a8	unknown	Unknown Device	f	2025-10-17 20:27:00.353576	2025-10-17 20:27:00.353576	1
8511b345-0d92-4c84-95a2-9d3483c8829e	FDA2BCA6-6C1A-4681-99BC-450713EDC958	iPhone	f	2025-10-14 21:25:09.934008	2025-10-14 21:25:09.934008	1
f1ba3a5e-b20d-410d-add0-1aefcf5717e5	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-17 00:15:11.899583	2025-10-17 20:53:08.25363	4
85453e87-deff-41d6-9e32-d3fc38eee454	2CACD9BD-47E4-4F81-8DFA-4E481AA74E86	iPhone	f	2025-10-16 22:24:25.074685	2025-10-17 20:57:59.310087	2
4fb71701-c436-49ab-950b-6b32b0141897	unknown	Unknown Device	f	2025-10-15 00:10:50.625484	2025-10-15 00:10:50.625484	1
3e3f2acf-0203-4e90-a862-b4d9306c2f45	32E10282-BB25-4566-BEFB-5F5CEDECF8FD	iPhone	f	2025-10-17 21:28:36.973762	2025-10-17 21:28:36.973762	1
\.


--
-- TOC entry 4360 (class 0 OID 25143)
-- Dependencies: 243
-- Data for Name: user_entitlements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_entitlements (id, user_id, product_id, subscription_group_id, original_transaction_id, original_transaction_id_hash, is_trial, status, purchase_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4340 (class 0 OID 24817)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, user_id, email, username, auth_provider, subscription_status, subscription_start_date, subscription_end_date, trial_started_at, promo_code_used, promo_activated_at, stripe_customer_id, stripe_subscription_id, is_active, is_banned, banned_reason, created_at, updated_at, last_active_at, password_hash, apple_user_id, apple_original_transaction_id, apple_product_id, apple_environment, grade) FROM stdin;
49	71cc27f6-5272-435c-a326-5853af953e77	mms4s7p7w6@privaterelay.appleid.com	John Apple	apple	trial	2025-10-14 17:47:21.497	2025-10-21 17:47:21.497	2025-10-14 17:47:21.508668	\N	\N	\N	\N	t	f	\N	2025-10-14 17:47:21.508668	2025-10-14 17:48:16.347539	2025-10-14 17:48:16.347539	\N	000737.325cbb3409ba488e8a757b1f81da5240.1747	\N	\N	Production	4th grade
35	610b14cb-c446-46b7-bcac-e0565e7ea5ea	test2@example.com	Test User 2	google	trial	2025-10-09 21:28:03.02	2025-10-16 21:28:03.02	2025-10-09 21:28:03.021143	\N	\N	\N	\N	t	f	\N	2025-10-09 21:28:03.021143	2025-10-09 21:28:03.021143	\N	\N	\N	\N	\N	Production	4th grade
60	3e3f2acf-0203-4e90-a862-b4d9306c2f45	8rqr4pk4zc@privaterelay.appleid.com	Joshua Nandeti	apple	expired	\N	\N	2025-10-17 21:28:36.62496	\N	\N	\N	\N	t	f	\N	2025-10-17 21:28:36.62496	2025-10-17 21:52:39.120666	2025-10-17 21:52:39.120666	\N	001547.8d922bb6e2e5414a99c70ff029d615f5.2128	\N	\N	Production	4th grade
53	4fb71701-c436-49ab-950b-6b32b0141897	test-deployment-1760487049@example.com	Test User	google	expired	\N	\N	2025-10-15 00:10:50.516672	\N	\N	\N	\N	t	f	\N	2025-10-15 00:10:50.516672	2025-10-15 00:10:50.516672	\N	\N	\N	\N	\N	Production	4th grade
47	3eb9d3cc-595d-402c-96ed-45439528954f	apple@arshia.com	apple@arshia.com	email	trial	2025-10-13 20:55:44.714	2025-11-12 20:55:44.714	2025-10-13 20:55:44.725305	\N	\N	\N	\N	t	f	\N	2025-10-13 20:55:44.725305	2025-10-14 23:25:45.791132	2025-10-14 23:25:45.791132	$2b$10$mDqR2TRnQSFnMOGHteLeluUGgJKCzQGSAdrlAwnaAcJx6VPxs63nO	\N	\N	\N	Production	4th grade
26	82c463e3-8349-4657-96a1-99ef136c9163	samipousti@gmail.com	Sami Pousti	google	expired	2025-10-09 01:58:46.847	2025-10-14 01:58:46.847	2025-10-09 01:58:46.848731	\N	\N	\N	\N	t	f	\N	2025-10-09 01:58:46.848731	2025-10-15 02:35:41.406034	2025-10-15 02:35:41.406034	\N	\N	\N	\N	Production	4th grade
59	f1ba3a5e-b20d-410d-add0-1aefcf5717e5	riahiarshia@gmail.com	Arshia Riahi	google	trial	\N	2025-10-24 20:30:07.965	2025-10-17 00:15:11.78404	\N	\N	\N	\N	t	f	\N	2025-10-17 00:15:11.78404	2025-10-17 20:57:44.039294	2025-10-17 20:57:44.039294	\N	\N	\N	\N	Production	4th grade
27	f99ca211-365b-4127-8958-350920e0ade0	parmidaamani@gmail.com	Parmida Amani	apple	trial	2025-10-09 02:47:19.575	2025-10-16 02:47:19.581	2025-10-09 02:47:19.671914	\N	\N	\N	\N	t	f	\N	2025-10-09 02:47:19.671914	2025-10-14 17:45:12.462921	2025-10-14 17:45:12.462921	\N	001116.68eed47adbd048439e62f4841f679b5d.0247	\N	\N	Production	4th grade
34	33bc2695-7dcf-4109-bb70-ffc6fcb958a8	test@example.com	Test User	google	trial	2025-10-09 21:27:51.434	2025-10-16 21:27:51.434	2025-10-09 21:27:51.435695	\N	\N	\N	\N	t	f	\N	2025-10-09 21:27:51.435695	2025-10-17 20:27:00.106321	2025-10-17 20:27:00.106321	\N	\N	\N	\N	Production	4th grade
28	1c8e4891-b32b-4cc0-b104-b99607e8afa7	ryan.smitty@gmail.com	Ryan Smith	google	trial	2025-10-09 04:14:37.589	2025-10-16 04:14:37.589	2025-10-09 04:14:37.595939	\N	\N	\N	\N	t	f	\N	2025-10-09 04:14:37.595939	2025-10-09 04:14:37.865271	2025-10-09 04:14:37.865271	\N	\N	\N	\N	Production	4th grade
50	8511b345-0d92-4c84-95a2-9d3483c8829e	6z44qyvynj@privaterelay.appleid.com	John Hebert	apple	trial	2025-10-14 21:25:09.673	2025-10-27 21:25:09.673	2025-10-14 21:25:09.682169	\N	\N	\N	\N	t	f	\N	2025-10-14 21:25:09.682169	2025-10-14 21:50:10.58801	2025-10-14 21:50:10.58801	\N	000017.4766c3ce97a8491aa1acc4d15cf71bdc.2125	\N	\N	Production	4th grade
36	8ca1bd33-89e6-4508-92df-872fc8450ef4	002023.0db4218bcf5a4eb6af61f054fc483304.2126@privaterelay.appleid.com	Apple User	apple	expired	2025-10-09 21:28:57.561	2025-10-09 21:28:57.561	2025-10-09 21:28:57.561877	\N	\N	\N	\N	t	f	\N	2025-10-09 21:28:57.561877	2025-10-14 16:43:22.722806	2025-10-14 16:43:22.722806	\N	002023.0db4218bcf5a4eb6af61f054fc483304.2126	\N	\N	Production	4th grade
37	81ec2385-7f7f-4db8-89b9-204d0c24a1df	rd6zmwd4qd@privaterelay.appleid.com	Sina Hajeb	apple	expired	2025-10-10 17:15:26.353	2025-10-10 17:15:26.353	2025-10-10 17:15:26.357765	\N	\N	\N	\N	t	f	\N	2025-10-10 17:15:26.357765	2025-10-12 08:03:27.028866	2025-10-12 08:03:27.028866	\N	001163.33a6faa9ac5046c9801e42196ba4a706.1715	\N	\N	Production	4th grade
58	85453e87-deff-41d6-9e32-d3fc38eee454	000757.afd07240d1514dfaa8b019bb4f89d2fe.2209@privaterelay.appleid.com		apple	trial	\N	2025-10-27 22:24:50.935	2025-10-16 22:24:24.997572	\N	\N	\N	\N	t	f	\N	2025-10-16 22:24:24.997572	2025-10-18 06:05:21.82259	2025-10-18 06:05:21.82259	\N	000757.afd07240d1514dfaa8b019bb4f89d2fe.2209	\N	\N	Production	4th grade
46	c21dc002-5828-4cd6-b414-4ef55a6d8e31	vpnadmaz@gmail.com	vpn admin	google	trial	2025-10-12 23:55:48.242	2025-10-19 23:55:48.242	2025-10-12 23:55:48.244418	\N	\N	\N	\N	t	f	\N	2025-10-12 23:55:48.244418	2025-10-16 22:23:20.553229	2025-10-16 22:23:20.553229	\N	\N	\N	\N	Production	4th grade
48	f6b7a96c-0c43-4b54-b25f-c419070bd59e	tt@arshia.com	tt@arshia.com	email	active	2025-10-13 21:09:48.047	2025-11-13 21:58:48	2025-10-13 21:09:48.048734	\N	\N	\N	\N	t	f	\N	2025-10-13 21:09:48.048734	2025-10-13 21:59:23.618151	2025-10-13 21:59:23.618151	$2b$10$dq6zvnhOoRXZZELh8esPn.vVQ.7X4dSnixbrLPHRGBWKfsuxXXcTq	\N	\N	\N	Production	4th grade
38	fc06e3c3-d68e-42aa-b584-b0a59ae8c718	sinaha10@gmail.com	Sina Hajeb	google	trial	2025-10-10 17:35:10.94	2025-10-17 17:35:10.94	2025-10-10 17:35:10.94331	\N	\N	\N	\N	t	f	\N	2025-10-10 17:35:10.94331	2025-10-12 21:18:01.202564	2025-10-12 21:18:01.202564	\N	\N	\N	\N	Production	4th grade
56	b1cfd676-d3dd-4979-9bef-7d79e7c36297	arshia@azpcc.org	Arshia Riahi	google	expired	\N	\N	2025-10-15 03:05:51.379654	\N	\N	\N	\N	t	f	\N	2025-10-15 03:05:51.379654	2025-10-17 19:33:36.543914	2025-10-17 19:33:36.543914	\N	\N	\N	\N	Production	4th grade
\.


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 245
-- Name: admin_audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_audit_log_id_seq', 3, true);


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 222
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_users_id_seq', 9, true);


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 229
-- Name: device_logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_logins_id_seq', 106, true);


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 231
-- Name: fraud_flags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fraud_flags_id_seq', 66, true);


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 247
-- Name: homework_submissions_submission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.homework_submissions_submission_id_seq', 1, true);


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 227
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.password_reset_tokens_id_seq', 19, true);


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 218
-- Name: promo_code_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promo_code_usage_id_seq', 1, false);


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 216
-- Name: promo_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promo_codes_id_seq', 3, true);


--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 220
-- Name: subscription_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subscription_history_id_seq', 85, true);


--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 241
-- Name: trial_usage_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trial_usage_history_id_seq', 1, false);


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 234
-- Name: user_api_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_api_usage_id_seq', 496, true);


--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 60, true);


--
-- TOC entry 4170 (class 2606 OID 25185)
-- Name: admin_audit_log admin_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_audit_log
    ADD CONSTRAINT admin_audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 24911)
-- Name: admin_users admin_users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_email_key UNIQUE (email);


--
-- TOC entry 4115 (class 2606 OID 24907)
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4117 (class 2606 OID 24909)
-- Name: admin_users admin_users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_username_key UNIQUE (username);


--
-- TOC entry 4129 (class 2606 OID 25008)
-- Name: device_logins device_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_logins
    ADD CONSTRAINT device_logins_pkey PRIMARY KEY (id);


--
-- TOC entry 4168 (class 2606 OID 25171)
-- Name: entitlements_ledger entitlements_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entitlements_ledger
    ADD CONSTRAINT entitlements_ledger_pkey PRIMARY KEY (id);


--
-- TOC entry 4134 (class 2606 OID 25023)
-- Name: fraud_flags fraud_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fraud_flags
    ADD CONSTRAINT fraud_flags_pkey PRIMARY KEY (id);


--
-- TOC entry 4175 (class 2606 OID 25204)
-- Name: homework_submissions homework_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homework_submissions
    ADD CONSTRAINT homework_submissions_pkey PRIMARY KEY (submission_id);


--
-- TOC entry 4125 (class 2606 OID 24952)
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4127 (class 2606 OID 24954)
-- Name: password_reset_tokens password_reset_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_token_key UNIQUE (token);


--
-- TOC entry 4104 (class 2606 OID 24863)
-- Name: promo_code_usage promo_code_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_code_usage
    ADD CONSTRAINT promo_code_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 4106 (class 2606 OID 24865)
-- Name: promo_code_usage promo_code_usage_promo_code_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_code_usage
    ADD CONSTRAINT promo_code_usage_promo_code_id_user_id_key UNIQUE (promo_code_id, user_id);


--
-- TOC entry 4098 (class 2606 OID 24852)
-- Name: promo_codes promo_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_code_key UNIQUE (code);


--
-- TOC entry 4100 (class 2606 OID 24850)
-- Name: promo_codes promo_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 4111 (class 2606 OID 24887)
-- Name: subscription_history subscription_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_history
    ADD CONSTRAINT subscription_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4156 (class 2606 OID 25137)
-- Name: trial_usage_history trial_usage_history_original_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trial_usage_history
    ADD CONSTRAINT trial_usage_history_original_transaction_id_key UNIQUE (original_transaction_id);


--
-- TOC entry 4158 (class 2606 OID 25135)
-- Name: trial_usage_history trial_usage_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trial_usage_history
    ADD CONSTRAINT trial_usage_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 25084)
-- Name: user_api_usage user_api_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_api_usage
    ADD CONSTRAINT user_api_usage_pkey PRIMARY KEY (id);


--
-- TOC entry 4143 (class 2606 OID 25038)
-- Name: user_devices user_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_pkey PRIMARY KEY (user_id, device_id);


--
-- TOC entry 4160 (class 2606 OID 25154)
-- Name: user_entitlements user_entitlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_entitlements
    ADD CONSTRAINT user_entitlements_pkey PRIMARY KEY (id);


--
-- TOC entry 4091 (class 2606 OID 24830)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4093 (class 2606 OID 24832)
-- Name: users users_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_id_key UNIQUE (user_id);


--
-- TOC entry 4164 (class 1259 OID 25174)
-- Name: ent_ledger_last_seen_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ent_ledger_last_seen_idx ON public.entitlements_ledger USING btree (last_seen_at);


--
-- TOC entry 4165 (class 1259 OID 25173)
-- Name: ent_ledger_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ent_ledger_status_idx ON public.entitlements_ledger USING btree (status);


--
-- TOC entry 4166 (class 1259 OID 25172)
-- Name: ent_ledger_txid_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ent_ledger_txid_hash_idx ON public.entitlements_ledger USING btree (original_transaction_id_hash);


--
-- TOC entry 4171 (class 1259 OID 25188)
-- Name: idx_admin_audit_log_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_audit_log_action ON public.admin_audit_log USING btree (action);


--
-- TOC entry 4172 (class 1259 OID 25186)
-- Name: idx_admin_audit_log_admin_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_audit_log_admin_user_id ON public.admin_audit_log USING btree (admin_user_id);


--
-- TOC entry 4173 (class 1259 OID 25187)
-- Name: idx_admin_audit_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_audit_log_created_at ON public.admin_audit_log USING btree (created_at);


--
-- TOC entry 4118 (class 1259 OID 24913)
-- Name: idx_admin_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_email ON public.admin_users USING btree (email);


--
-- TOC entry 4119 (class 1259 OID 24912)
-- Name: idx_admin_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_admin_username ON public.admin_users USING btree (username);


--
-- TOC entry 4081 (class 1259 OID 25114)
-- Name: idx_apple_original_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_apple_original_transaction_id ON public.users USING btree (apple_original_transaction_id);


--
-- TOC entry 4082 (class 1259 OID 25115)
-- Name: idx_apple_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_apple_product_id ON public.users USING btree (apple_product_id);


--
-- TOC entry 4130 (class 1259 OID 25009)
-- Name: idx_device_logins_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_logins_device_id ON public.device_logins USING btree (device_id);


--
-- TOC entry 4131 (class 1259 OID 25011)
-- Name: idx_device_logins_login_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_logins_login_time ON public.device_logins USING btree (login_time);


--
-- TOC entry 4132 (class 1259 OID 25010)
-- Name: idx_device_logins_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_logins_user_id ON public.device_logins USING btree (user_id);


--
-- TOC entry 4135 (class 1259 OID 25025)
-- Name: idx_fraud_flags_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fraud_flags_device_id ON public.fraud_flags USING btree (device_id);


--
-- TOC entry 4136 (class 1259 OID 25026)
-- Name: idx_fraud_flags_resolved; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fraud_flags_resolved ON public.fraud_flags USING btree (resolved);


--
-- TOC entry 4137 (class 1259 OID 25027)
-- Name: idx_fraud_flags_severity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fraud_flags_severity ON public.fraud_flags USING btree (severity);


--
-- TOC entry 4138 (class 1259 OID 25024)
-- Name: idx_fraud_flags_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fraud_flags_user_id ON public.fraud_flags USING btree (user_id);


--
-- TOC entry 4176 (class 1259 OID 25211)
-- Name: idx_homework_submissions_problem_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_homework_submissions_problem_id ON public.homework_submissions USING btree (problem_id);


--
-- TOC entry 4177 (class 1259 OID 25213)
-- Name: idx_homework_submissions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_homework_submissions_status ON public.homework_submissions USING btree (status);


--
-- TOC entry 4178 (class 1259 OID 25212)
-- Name: idx_homework_submissions_submitted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_homework_submissions_submitted_at ON public.homework_submissions USING btree (submitted_at);


--
-- TOC entry 4179 (class 1259 OID 25210)
-- Name: idx_homework_submissions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_homework_submissions_user_id ON public.homework_submissions USING btree (user_id);


--
-- TOC entry 4120 (class 1259 OID 24962)
-- Name: idx_password_reset_tokens_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_expires_at ON public.password_reset_tokens USING btree (expires_at);


--
-- TOC entry 4121 (class 1259 OID 24960)
-- Name: idx_password_reset_tokens_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_token ON public.password_reset_tokens USING btree (token);


--
-- TOC entry 4122 (class 1259 OID 24963)
-- Name: idx_password_reset_tokens_used; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_used ON public.password_reset_tokens USING btree (used);


--
-- TOC entry 4123 (class 1259 OID 24961)
-- Name: idx_password_reset_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_password_reset_tokens_user_id ON public.password_reset_tokens USING btree (user_id);


--
-- TOC entry 4094 (class 1259 OID 24854)
-- Name: idx_promo_codes_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_codes_active ON public.promo_codes USING btree (active);


--
-- TOC entry 4095 (class 1259 OID 24853)
-- Name: idx_promo_codes_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_codes_code ON public.promo_codes USING btree (code);


--
-- TOC entry 4096 (class 1259 OID 24855)
-- Name: idx_promo_codes_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_codes_expires_at ON public.promo_codes USING btree (expires_at);


--
-- TOC entry 4101 (class 1259 OID 24876)
-- Name: idx_promo_usage_promo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_usage_promo_id ON public.promo_code_usage USING btree (promo_code_id);


--
-- TOC entry 4102 (class 1259 OID 24877)
-- Name: idx_promo_usage_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promo_usage_user_id ON public.promo_code_usage USING btree (user_id);


--
-- TOC entry 4107 (class 1259 OID 24895)
-- Name: idx_sub_history_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_history_created_at ON public.subscription_history USING btree (created_at);


--
-- TOC entry 4108 (class 1259 OID 24894)
-- Name: idx_sub_history_event_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_history_event_type ON public.subscription_history USING btree (event_type);


--
-- TOC entry 4109 (class 1259 OID 24893)
-- Name: idx_sub_history_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_history_user_id ON public.subscription_history USING btree (user_id);


--
-- TOC entry 4152 (class 1259 OID 25140)
-- Name: idx_trial_history_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trial_history_created_at ON public.trial_usage_history USING btree (created_at);


--
-- TOC entry 4153 (class 1259 OID 25138)
-- Name: idx_trial_history_original_transaction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trial_history_original_transaction ON public.trial_usage_history USING btree (original_transaction_id);


--
-- TOC entry 4154 (class 1259 OID 25139)
-- Name: idx_trial_history_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trial_history_user_id ON public.trial_usage_history USING btree (user_id);


--
-- TOC entry 4144 (class 1259 OID 25086)
-- Name: idx_user_api_usage_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_created_at ON public.user_api_usage USING btree (created_at);


--
-- TOC entry 4145 (class 1259 OID 25108)
-- Name: idx_user_api_usage_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_device_id ON public.user_api_usage USING btree (device_id);


--
-- TOC entry 4146 (class 1259 OID 25087)
-- Name: idx_user_api_usage_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_endpoint ON public.user_api_usage USING btree (endpoint);


--
-- TOC entry 4147 (class 1259 OID 25089)
-- Name: idx_user_api_usage_model; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_model ON public.user_api_usage USING btree (model);


--
-- TOC entry 4148 (class 1259 OID 25088)
-- Name: idx_user_api_usage_user_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_user_date ON public.user_api_usage USING btree (user_id, created_at);


--
-- TOC entry 4149 (class 1259 OID 25085)
-- Name: idx_user_api_usage_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_api_usage_user_id ON public.user_api_usage USING btree (user_id);


--
-- TOC entry 4139 (class 1259 OID 25040)
-- Name: idx_user_devices_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_devices_device_id ON public.user_devices USING btree (device_id);


--
-- TOC entry 4140 (class 1259 OID 25041)
-- Name: idx_user_devices_trusted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_devices_trusted ON public.user_devices USING btree (is_trusted);


--
-- TOC entry 4141 (class 1259 OID 25039)
-- Name: idx_user_devices_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_devices_user_id ON public.user_devices USING btree (user_id);


--
-- TOC entry 4083 (class 1259 OID 24964)
-- Name: idx_users_apple_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_apple_user_id ON public.users USING btree (apple_user_id);


--
-- TOC entry 4084 (class 1259 OID 24834)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 4085 (class 1259 OID 24931)
-- Name: idx_users_password_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_password_hash ON public.users USING btree (password_hash);


--
-- TOC entry 4086 (class 1259 OID 24837)
-- Name: idx_users_stripe_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_stripe_customer_id ON public.users USING btree (stripe_customer_id);


--
-- TOC entry 4087 (class 1259 OID 24836)
-- Name: idx_users_subscription_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_subscription_end_date ON public.users USING btree (subscription_end_date);


--
-- TOC entry 4088 (class 1259 OID 24835)
-- Name: idx_users_subscription_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_subscription_status ON public.users USING btree (subscription_status);


--
-- TOC entry 4089 (class 1259 OID 24833)
-- Name: idx_users_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_user_id ON public.users USING btree (user_id);


--
-- TOC entry 4161 (class 1259 OID 25157)
-- Name: user_entitlements_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_entitlements_status_idx ON public.user_entitlements USING btree (status);


--
-- TOC entry 4162 (class 1259 OID 25156)
-- Name: user_entitlements_txid_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_entitlements_txid_hash_idx ON public.user_entitlements USING btree (original_transaction_id_hash);


--
-- TOC entry 4163 (class 1259 OID 25155)
-- Name: user_entitlements_user_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_entitlements_user_idx ON public.user_entitlements USING btree (user_id);


--
-- TOC entry 4333 (class 2618 OID 24929)
-- Name: promo_code_stats _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE OR REPLACE VIEW public.promo_code_stats AS
 SELECT pc.code,
    pc.duration_days,
    pc.uses_total,
    pc.uses_remaining,
    pc.active,
    count(pcu.id) AS actual_uses,
    pc.created_at
   FROM (public.promo_codes pc
     LEFT JOIN public.promo_code_usage pcu ON ((pc.id = pcu.promo_code_id)))
  GROUP BY pc.id;


--
-- TOC entry 4185 (class 2620 OID 24917)
-- Name: users set_trial_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_trial_on_insert BEFORE INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_trial_dates();


--
-- TOC entry 4187 (class 2620 OID 25142)
-- Name: trial_usage_history trigger_update_trial_history_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_trial_history_timestamp BEFORE UPDATE ON public.trial_usage_history FOR EACH ROW EXECUTE FUNCTION public.update_trial_history_updated_at();


--
-- TOC entry 4188 (class 2620 OID 25159)
-- Name: user_entitlements trigger_update_user_entitlements_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_user_entitlements_timestamp BEFORE UPDATE ON public.user_entitlements FOR EACH ROW EXECUTE FUNCTION public.update_user_entitlements_updated_at();


--
-- TOC entry 4186 (class 2620 OID 24915)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4184 (class 2606 OID 25205)
-- Name: homework_submissions homework_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homework_submissions
    ADD CONSTRAINT homework_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4183 (class 2606 OID 24955)
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4180 (class 2606 OID 24866)
-- Name: promo_code_usage promo_code_usage_promo_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_code_usage
    ADD CONSTRAINT promo_code_usage_promo_code_id_fkey FOREIGN KEY (promo_code_id) REFERENCES public.promo_codes(id) ON DELETE CASCADE;


--
-- TOC entry 4181 (class 2606 OID 24871)
-- Name: promo_code_usage promo_code_usage_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promo_code_usage
    ADD CONSTRAINT promo_code_usage_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4182 (class 2606 OID 24888)
-- Name: subscription_history subscription_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_history
    ADD CONSTRAINT subscription_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2025-10-18 15:21:28 MST

--
-- PostgreSQL database dump complete
--

\unrestrict He0FjsERK1qqx7kKdeUV2Nek6cGqe6CWCk3k3cUA7HV5Us0QsUevNJ4rjMXyoLd

