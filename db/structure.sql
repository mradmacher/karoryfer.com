--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE albums (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    year integer NOT NULL,
    artist_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    license_id integer,
    reference character varying(80) NOT NULL,
    donation text,
    description text,
    published boolean DEFAULT false NOT NULL,
    image character varying(255),
    file character varying(255),
    CONSTRAINT albums_reference_check_format CHECK (((reference)::text = COALESCE("substring"((reference)::text, '(^[a-z0-9]+([-][a-z0-9]+)*$)'::text), ''::text))),
    CONSTRAINT albums_reference_check_length CHECK ((char_length((reference)::text) > 0))
);


--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE albums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE albums_id_seq OWNED BY albums.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    reference character varying(80) NOT NULL,
    summary character varying(255),
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    image character varying(255),
    CONSTRAINT artists_reference_check_format CHECK (((reference)::text = COALESCE("substring"((reference)::text, '(^[a-z0-9]+([-_][a-z0-9]+)*$)'::text), ''::text))),
    CONSTRAINT artists_reference_check_length CHECK ((char_length((reference)::text) > 0))
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attachments (
    id integer NOT NULL,
    album_id integer NOT NULL,
    file character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT attachments_file_check_blank CHECK ((btrim((file)::text) <> ''::text))
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    title character varying(80) NOT NULL,
    body text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    external_urls text,
    location character varying(80),
    duration integer DEFAULT 0 NOT NULL,
    event_date date DEFAULT ('now'::text)::date NOT NULL,
    address character varying(255),
    event_time character varying(255),
    free_entrance boolean DEFAULT false NOT NULL,
    price character varying(255),
    poster character varying(255),
    CONSTRAINT events_title_check_blank CHECK ((btrim((title)::text) <> ''::text))
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE licenses (
    id integer NOT NULL,
    symbol character varying(16) NOT NULL,
    version character varying(16) NOT NULL,
    name character varying(16) NOT NULL
);


--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licenses_id_seq OWNED BY licenses.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    reference character varying(80) NOT NULL,
    title character varying(80) NOT NULL,
    content text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    artist_id integer NOT NULL,
    CONSTRAINT pages_reference_check_blank CHECK ((btrim((reference)::text) <> ''::text)),
    CONSTRAINT pages_reference_check_format CHECK (("substring"((reference)::text, '(^[a-z0-9]+(-[a-z0-9]+)*$)'::text) IS NOT NULL)),
    CONSTRAINT pages_title_check_blank CHECK ((btrim((title)::text) <> ''::text))
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    title character varying(80),
    body text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: releases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE releases (
    id integer NOT NULL,
    album_id integer,
    track_id integer,
    format character varying(10) NOT NULL,
    file character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT releases_format_check_blank CHECK ((btrim((format)::text) <> ''::text)),
    CONSTRAINT releases_releaseable_check CHECK ((((album_id IS NOT NULL) AND (track_id IS NULL)) OR ((album_id IS NULL) AND (track_id IS NOT NULL))))
);


--
-- Name: releases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE releases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: releases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE releases_id_seq OWNED BY releases.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tracks (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    album_id integer NOT NULL,
    rank integer NOT NULL,
    comment character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    file character varying(255),
    CONSTRAINT tracks_rank_check CHECK ((rank > 0))
);


--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tracks_id_seq OWNED BY tracks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying(32) NOT NULL,
    email character varying(255),
    admin boolean DEFAULT false NOT NULL,
    crypted_password character varying(255),
    password_salt character varying(255),
    persistence_token character varying(255),
    login_count integer DEFAULT 0,
    failed_login_count integer DEFAULT 0,
    current_login_at timestamp without time zone,
    last_login_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    publisher boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE videos (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    title character varying(80) NOT NULL,
    url character varying(80) NOT NULL,
    body text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT videos_title_check_blank CHECK ((btrim((title)::text) <> ''::text))
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY albums ALTER COLUMN id SET DEFAULT nextval('albums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY licenses ALTER COLUMN id SET DEFAULT nextval('licenses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY releases ALTER COLUMN id SET DEFAULT nextval('releases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracks ALTER COLUMN id SET DEFAULT nextval('tracks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Name: albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: albums_reference_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT albums_reference_key UNIQUE (reference);


--
-- Name: artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: artists_reference_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_reference_key UNIQUE (reference);


--
-- Name: attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: pages_artist_reference_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_artist_reference_key UNIQUE (artist_id, reference);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: releases_album_format_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY releases
    ADD CONSTRAINT releases_album_format_key UNIQUE (album_id, format);


--
-- Name: releases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (id);


--
-- Name: releases_track_format_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY releases
    ADD CONSTRAINT releases_track_format_key UNIQUE (track_id, format);


--
-- Name: schema_migrations_version_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_version_key UNIQUE (version);


--
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: users_login_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: albums_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX albums_artist_id_index ON albums USING btree (artist_id);


--
-- Name: attachments_album_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX attachments_album_id_index ON attachments USING btree (album_id);


--
-- Name: events_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX events_artist_id_index ON events USING btree (artist_id);


--
-- Name: memberships_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX memberships_artist_id_index ON memberships USING btree (artist_id);


--
-- Name: memberships_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX memberships_user_id_index ON memberships USING btree (user_id);


--
-- Name: pages_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX pages_artist_id_index ON pages USING btree (artist_id);


--
-- Name: posts_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX posts_artist_id_index ON posts USING btree (artist_id);


--
-- Name: releases_album_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX releases_album_id_index ON releases USING btree (album_id);


--
-- Name: releases_track_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX releases_track_id_index ON releases USING btree (track_id);


--
-- Name: tracks_album_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tracks_album_id_index ON tracks USING btree (album_id);


--
-- Name: videos_artist_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX videos_artist_id_index ON videos USING btree (artist_id);


--
-- Name: albums_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT albums_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE RESTRICT;


--
-- Name: albums_license_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT albums_license_id_fkey FOREIGN KEY (license_id) REFERENCES licenses(id) ON DELETE RESTRICT;


--
-- Name: attachments_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_album_id_fkey FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE;


--
-- Name: events_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;


--
-- Name: memberships_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;


--
-- Name: memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: pages_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;


--
-- Name: posts_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;


--
-- Name: releases_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY releases
    ADD CONSTRAINT releases_album_id_fkey FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE;


--
-- Name: releases_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY releases
    ADD CONSTRAINT releases_track_id_fkey FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE;


--
-- Name: tracks_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_album_id_fkey FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE RESTRICT;


--
-- Name: videos_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20120111181336');

INSERT INTO schema_migrations (version) VALUES ('20120113220405');

INSERT INTO schema_migrations (version) VALUES ('20120114080804');

INSERT INTO schema_migrations (version) VALUES ('20120117203259');

INSERT INTO schema_migrations (version) VALUES ('20120117203547');

INSERT INTO schema_migrations (version) VALUES ('20120117203559');

INSERT INTO schema_migrations (version) VALUES ('20120118051400');

INSERT INTO schema_migrations (version) VALUES ('20120118054914');

INSERT INTO schema_migrations (version) VALUES ('20120118185731');

INSERT INTO schema_migrations (version) VALUES ('20120118193106');

INSERT INTO schema_migrations (version) VALUES ('20120118203728');

INSERT INTO schema_migrations (version) VALUES ('20120118223916');

INSERT INTO schema_migrations (version) VALUES ('20120119205716');

INSERT INTO schema_migrations (version) VALUES ('20120119230127');

INSERT INTO schema_migrations (version) VALUES ('20120120175601');

INSERT INTO schema_migrations (version) VALUES ('20120120180217');

INSERT INTO schema_migrations (version) VALUES ('20120120180826');

INSERT INTO schema_migrations (version) VALUES ('20120120181741');

INSERT INTO schema_migrations (version) VALUES ('20120120181947');

INSERT INTO schema_migrations (version) VALUES ('20120205215633');

INSERT INTO schema_migrations (version) VALUES ('20120205215703');

INSERT INTO schema_migrations (version) VALUES ('20120209235326');

INSERT INTO schema_migrations (version) VALUES ('20120218132225');

INSERT INTO schema_migrations (version) VALUES ('20120218144936');

INSERT INTO schema_migrations (version) VALUES ('20120218183757');

INSERT INTO schema_migrations (version) VALUES ('20120218193555');

INSERT INTO schema_migrations (version) VALUES ('20120219192528');

INSERT INTO schema_migrations (version) VALUES ('20120219192546');

INSERT INTO schema_migrations (version) VALUES ('20120219193243');

INSERT INTO schema_migrations (version) VALUES ('20120225203038');

INSERT INTO schema_migrations (version) VALUES ('20120225223250');

INSERT INTO schema_migrations (version) VALUES ('20120316230147');

INSERT INTO schema_migrations (version) VALUES ('20120410213447');

INSERT INTO schema_migrations (version) VALUES ('20120425204427');

INSERT INTO schema_migrations (version) VALUES ('20120516212528');

INSERT INTO schema_migrations (version) VALUES ('20120601211321');

INSERT INTO schema_migrations (version) VALUES ('20120601211554');

INSERT INTO schema_migrations (version) VALUES ('20120601211711');

INSERT INTO schema_migrations (version) VALUES ('20120611212218');

INSERT INTO schema_migrations (version) VALUES ('20120701134439');

INSERT INTO schema_migrations (version) VALUES ('20120701142944');

INSERT INTO schema_migrations (version) VALUES ('20120702185726');

INSERT INTO schema_migrations (version) VALUES ('20120710191956');

INSERT INTO schema_migrations (version) VALUES ('20120710205426');

INSERT INTO schema_migrations (version) VALUES ('20120724211754');

INSERT INTO schema_migrations (version) VALUES ('20120908185138');

INSERT INTO schema_migrations (version) VALUES ('20120912220413');

INSERT INTO schema_migrations (version) VALUES ('20120914222448');

INSERT INTO schema_migrations (version) VALUES ('20120929221955');

INSERT INTO schema_migrations (version) VALUES ('20120929222011');

INSERT INTO schema_migrations (version) VALUES ('20120930002907');

INSERT INTO schema_migrations (version) VALUES ('20121223160326');

INSERT INTO schema_migrations (version) VALUES ('20130120101735');

INSERT INTO schema_migrations (version) VALUES ('20130120101758');

INSERT INTO schema_migrations (version) VALUES ('20130120122248');

INSERT INTO schema_migrations (version) VALUES ('20130120123747');

INSERT INTO schema_migrations (version) VALUES ('20130120225624');

INSERT INTO schema_migrations (version) VALUES ('20130121230719');

INSERT INTO schema_migrations (version) VALUES ('20130124201127');

INSERT INTO schema_migrations (version) VALUES ('20130124201207');

INSERT INTO schema_migrations (version) VALUES ('20130124202404');

INSERT INTO schema_migrations (version) VALUES ('20130124214400');

INSERT INTO schema_migrations (version) VALUES ('20130124215420');

INSERT INTO schema_migrations (version) VALUES ('20130124223907');

INSERT INTO schema_migrations (version) VALUES ('20130124225935');

INSERT INTO schema_migrations (version) VALUES ('20130126142942');

INSERT INTO schema_migrations (version) VALUES ('20130126193821');

INSERT INTO schema_migrations (version) VALUES ('20130126193851');

INSERT INTO schema_migrations (version) VALUES ('20130126193911');

INSERT INTO schema_migrations (version) VALUES ('20130126193940');

INSERT INTO schema_migrations (version) VALUES ('20130127091845');

INSERT INTO schema_migrations (version) VALUES ('20130127093448');

INSERT INTO schema_migrations (version) VALUES ('20130127101438');

INSERT INTO schema_migrations (version) VALUES ('20130127190104');

INSERT INTO schema_migrations (version) VALUES ('20130130214455');

INSERT INTO schema_migrations (version) VALUES ('20130312215411');

INSERT INTO schema_migrations (version) VALUES ('20130313081120');

INSERT INTO schema_migrations (version) VALUES ('20130313093039');

INSERT INTO schema_migrations (version) VALUES ('20130313191457');

INSERT INTO schema_migrations (version) VALUES ('20130410181037');

INSERT INTO schema_migrations (version) VALUES ('20130410190418');

INSERT INTO schema_migrations (version) VALUES ('20130413194456');

INSERT INTO schema_migrations (version) VALUES ('20130414203753');

INSERT INTO schema_migrations (version) VALUES ('20130416214909');

INSERT INTO schema_migrations (version) VALUES ('20130419191304');

INSERT INTO schema_migrations (version) VALUES ('20130428204939');

INSERT INTO schema_migrations (version) VALUES ('20130508153129');

INSERT INTO schema_migrations (version) VALUES ('20130513221849');

INSERT INTO schema_migrations (version) VALUES ('20130521151717');

INSERT INTO schema_migrations (version) VALUES ('20130521152544');

INSERT INTO schema_migrations (version) VALUES ('20130521155849');

INSERT INTO schema_migrations (version) VALUES ('20130521162201');

INSERT INTO schema_migrations (version) VALUES ('20130925164159');

INSERT INTO schema_migrations (version) VALUES ('20131028202746');

INSERT INTO schema_migrations (version) VALUES ('20131031212642');

INSERT INTO schema_migrations (version) VALUES ('20131103141046');

INSERT INTO schema_migrations (version) VALUES ('20131209212810');

INSERT INTO schema_migrations (version) VALUES ('20131221223326');

INSERT INTO schema_migrations (version) VALUES ('20131222223845');

INSERT INTO schema_migrations (version) VALUES ('20131230200147');

INSERT INTO schema_migrations (version) VALUES ('20131230210259');

INSERT INTO schema_migrations (version) VALUES ('20131230212434');

INSERT INTO schema_migrations (version) VALUES ('20131230222123');

INSERT INTO schema_migrations (version) VALUES ('20140101134218');

INSERT INTO schema_migrations (version) VALUES ('20140101193330');

INSERT INTO schema_migrations (version) VALUES ('20140102203007');

INSERT INTO schema_migrations (version) VALUES ('20140104013708');

INSERT INTO schema_migrations (version) VALUES ('20140104015041');

INSERT INTO schema_migrations (version) VALUES ('20140119201221');

INSERT INTO schema_migrations (version) VALUES ('20140210205054');

INSERT INTO schema_migrations (version) VALUES ('20140210205102');

INSERT INTO schema_migrations (version) VALUES ('20140527204826');

INSERT INTO schema_migrations (version) VALUES ('20140529063208');