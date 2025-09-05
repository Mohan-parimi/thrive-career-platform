-- Database Schema for Thrive - Be your own G
-- Run this SQL in your Supabase SQL Editor

-- Note: JWT secret is automatically managed by Supabase

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name TEXT,
    email TEXT UNIQUE,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    video_url TEXT NOT NULL,
    thumbnail_url TEXT,
    category TEXT NOT NULL,
    difficulty TEXT,
    duration TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resources table
CREATE TABLE IF NOT EXISTS resources (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    file_url TEXT NOT NULL,
    file_type TEXT NOT NULL,
    category TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create FAQ table
CREATE TABLE IF NOT EXISTS faq (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create chat_sessions table
CREATE TABLE IF NOT EXISTS chat_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    messages JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resume_scores table
CREATE TABLE IF NOT EXISTS resume_scores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    ats_score INTEGER,
    suggestions JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE faq ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_scores ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for profiles (simplified for now)
CREATE POLICY "Anyone can view profiles" ON profiles
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert profiles" ON profiles
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update profiles" ON profiles
    FOR UPDATE USING (true);

-- Create RLS policies for courses (public read access)
CREATE POLICY "Anyone can view courses" ON courses
    FOR SELECT USING (true);

-- Create RLS policies for resources (public read access)
CREATE POLICY "Anyone can view resources" ON resources
    FOR SELECT USING (true);

-- Create RLS policies for FAQ (public read access)
CREATE POLICY "Anyone can view FAQ" ON faq
    FOR SELECT USING (true);

-- Create RLS policies for chat_sessions (simplified for now)
CREATE POLICY "Anyone can view chat sessions" ON chat_sessions
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert chat sessions" ON chat_sessions
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update chat sessions" ON chat_sessions
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete chat sessions" ON chat_sessions
    FOR DELETE USING (true);

-- Create RLS policies for resume_scores (simplified for now)
CREATE POLICY "Anyone can view resume scores" ON resume_scores
    FOR SELECT USING (true);

CREATE POLICY "Anyone can insert resume scores" ON resume_scores
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update resume scores" ON resume_scores
    FOR UPDATE USING (true);

CREATE POLICY "Anyone can delete resume scores" ON resume_scores
    FOR DELETE USING (true);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chat_sessions_updated_at BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO courses (title, description, video_url, category, difficulty, duration) VALUES
('Introduction to Career Development', 'Learn the fundamentals of building a successful career', 'https://example.com/video1', 'Career Development', 'Beginner', '30 minutes'),
('Resume Writing Masterclass', 'Master the art of writing compelling resumes', 'https://example.com/video2', 'Resume Building', 'Intermediate', '45 minutes'),
('Interview Preparation', 'Prepare for your next job interview with confidence', 'https://example.com/video3', 'Interview Skills', 'Advanced', '60 minutes');

INSERT INTO resources (title, description, file_url, file_type, category) VALUES
('Resume Template - Modern', 'A clean, modern resume template', 'https://example.com/resume-template.pdf', 'PDF', 'Templates'),
('Cover Letter Guide', 'Complete guide to writing effective cover letters', 'https://example.com/cover-letter-guide.pdf', 'PDF', 'Guides'),
('Interview Questions Database', 'Common interview questions and answers', 'https://example.com/interview-questions.pdf', 'PDF', 'Interview Prep');

INSERT INTO faq (question, answer, category) VALUES
('How do I improve my ATS score?', 'Focus on using relevant keywords, proper formatting, and clear sections in your resume.', 'ATS'),
('What makes a good cover letter?', 'A good cover letter should be personalized, highlight relevant achievements, and show enthusiasm for the role.', 'Cover Letters'),
('How often should I update my resume?', 'Update your resume every 6 months or whenever you gain new skills or experiences.', 'General');

